module Webpack.IsomorphicClientPagesLoader (loader) where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign
import Foreign as Foreign
import Pathy
import Webpack.Loader
import LoaderUtils
import Webpack.GetClientPagesEntrypoints
-- | import Data.Argonaut.Decode (JsonDecodeError)
-- | import Data.Argonaut.Decode as ArgonautCodecs
-- | import Data.Argonaut.Decode.Decoders
import Data.Argonaut.Core (Json)
import Data.String as String
import Pathy
import Data.Codec
import Data.Codec.Argonaut (JsonCodec, JsonDecodeError(..))
import Data.Codec.Argonaut as Codec.Argonaut
import Data.Codec.Argonaut.Common as Codec.Argonaut
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Profunctor (dimap)
import Data.Newtype
import Node.Buffer as Node.Buffer
import Node.Encoding as Node.Encoding
import ModuleName
import NextjsApp.Route (PagesRec, PagesRecRow, Route)

type Options = Tuple Route Options

prismaticCodecNamed :: forall a b . String -> (a -> Maybe b) -> (b -> a) -> JsonCodec a -> JsonCodec b
prismaticCodecNamed name decode encode codec = Codec.Argonaut.prismaticCodec decode encode codec # hoistCodec (lmap (Named name))

nonEmptyStringCodec ∷ JsonCodec NonEmptyString
nonEmptyStringCodec = prismaticCodecNamed "NonEmptyString" NonEmptyString.fromString NonEmptyString.toString Codec.Argonaut.string

nonEmptyArrayCodec ∷ forall a . JsonCodec a -> JsonCodec (NonEmptyArray a)
nonEmptyArrayCodec codec = prismaticCodecNamed "NonEmptyArray" NonEmptyArray.fromArray NonEmptyArray.toArray $ Codec.Argonaut.array codec

routeCodec ∷ JsonCodec ModuleName
routeCodec = dimap unwrap wrap (nonEmptyArrayCodec nonEmptyStringCodec)

absFileCodec
  ∷ { parser :: Parser
    , printer :: Printer
    , sandboxer :: Path Abs File -> SandboxedPath Abs File
    }
  -> JsonCodec (Path Abs File)
absFileCodec config = prismaticCodecNamed "Path Abs File" (parseAbsFile config.parser) (printPath config.printer <<< config.sandboxer) Codec.Argonaut.string

absFileCodecPosixRoot :: JsonCodec (Path Abs File)
absFileCodecPosixRoot = absFileCodec
  { parser:    posixParser
  , printer:   posixPrinter
  , sandboxer: sandboxAny
  }

clientPagesLoaderOptionsCodec :: JsonCodec ClientPagesLoaderOptions
clientPagesLoaderOptionsCodec =
  Codec.Argonaut.object "ClientPagesLoaderOptions" $ Codec.Argonaut.record
    # Codec.Argonaut.recordProp (SProxy :: _ "absoluteCompiledPagePursPath") absFileCodecPosixRoot
    # Codec.Argonaut.recordProp (SProxy :: _ "absoluteJsDepsPath") (Codec.Argonaut.maybe absFileCodecPosixRoot)

optionsCodec :: JsonCodec (PagesRec ClientPagesLoaderOptions)
optionsCodec = Codec.Argonaut.tuple moduleNameCodec clientPagesLoaderOptionsCodec

-- | TODO:
-- | ModuleName - full name of module, e.g. ["NextjsApp", "Pages", "Examples", "Ace"]
-- | printed ModuleName - module name as in purescript, "NextjsApp.Pages.Examples.Ace"
-- | Page or Route - e.g. Examples__Ace
-- | PageId - string repr of Page, .e.g "Examples__Ace", this occurs in PagesRec
-- | pageIdSeparator - e.g. "__"

-- Not Route but Page?

loader :: Loader
loader = mkAsyncLoader \context buffer -> liftEffect do
  (options :: Json) <- getOptions context

  (moduleName /\ clientPagesLoaderOptions) <-
    case Codec.Argonaut.decode optionsCodec options of
       Left decodeError -> throwError $ error $ Codec.Argonaut.printJsonDecodeError decodeError
       Right options' -> pure options'

  let
    source = String.joinWith "" <<< map (\x -> x <> ";") $
      [ case clientPagesLoaderOptions.absoluteJsDepsPath of
             Nothing -> ""
             Just absoluteJsDepsPath -> "require(" <> printPath posixPrinter (sandboxAny absoluteJsDepsPath) <> ")"
      , String.joinWith ""
          [ "(window.__PAGE_CACHE_BUS=window.__PAGE_CACHE_BUS||[]).push({ pageName:"
          , moduleNameToManifestPageId moduleName
          , ", page: require("
          , printPath posixPrinter (sandboxAny clientPagesLoaderOptions.absoluteCompiledPagePursPath)
          , ").page })"
          ]
      ]

  source' <- Node.Buffer.fromString source Node.Encoding.UTF8

  pure { source: source' }

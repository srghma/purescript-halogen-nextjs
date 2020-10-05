module NextjsWebpack.IsomorphicClientPagesLoader (loader, optionsCodec) where

import Control.Promise
import Data.Codec
import Data.Newtype
import Effect.Uncurried
import Foreign
import LoaderUtils
import ModuleName
import NextjsWebpack.GetClientPagesEntrypoints
import Pathy
import Pathy
import Protolude
import Webpack.Loader

import Data.Argonaut.Core (Json)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Codec.Argonaut (JsonCodec, JsonDecodeError(..))
import Data.Codec.Argonaut as Codec.Argonaut
import Data.Codec.Argonaut.Common as Codec.Argonaut
import Data.Lens as Lens
import Data.Lens.Iso as Lens
import Data.Profunctor (dimap)
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Foreign as Foreign
import NextjsApp.Route (RouteIdMapping, RouteIdMappingRow, Route, RouteId)
import NextjsApp.Route as NextjsApp.Route
import Node.Buffer as Node.Buffer
import Node.Encoding as Node.Encoding
import PathyExtra

type Options = Tuple Route ClientPagesLoaderOptions

prismaticCodecNamed :: forall a b . String -> (a -> Maybe b) -> (b -> a) -> JsonCodec a -> JsonCodec b
prismaticCodecNamed name decode encode codec = Codec.Argonaut.prismaticCodec decode encode codec # hoistCodec (lmap (Named name))

nonEmptyStringCodec ∷ JsonCodec NonEmptyString
nonEmptyStringCodec = prismaticCodecNamed "NonEmptyString" NonEmptyString.fromString NonEmptyString.toString Codec.Argonaut.string

nonEmptyArrayCodec ∷ forall a . JsonCodec a -> JsonCodec (NonEmptyArray a)
nonEmptyArrayCodec codec = prismaticCodecNamed "NonEmptyArray" NonEmptyArray.fromArray NonEmptyArray.toArray (Codec.Argonaut.array codec)

routeIdCodec ∷ JsonCodec RouteId
routeIdCodec = prismaticCodecNamed "RouteId" NextjsApp.Route.stringToMaybeRouteId NextjsApp.Route.routeIdToString Codec.Argonaut.string

routeCodec ∷ JsonCodec Route
routeCodec = dimap (Lens.view NextjsApp.Route._routeToRouteIdIso) (Lens.review NextjsApp.Route._routeToRouteIdIso) routeIdCodec

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

optionsCodec :: JsonCodec Options
optionsCodec = Codec.Argonaut.tuple routeCodec clientPagesLoaderOptionsCodec

loader :: Loader
loader = mkAsyncLoader \context buffer -> liftEffect do
  (options :: Json) <- getOptions context

  (route /\ clientPagesLoaderOptions) <-
    case Codec.Argonaut.decode optionsCodec options of
       Left decodeError -> throwError $ error $ Codec.Argonaut.printJsonDecodeError decodeError
       Right options' -> pure options'

  let
    source = String.joinWith "" <<< map (\x -> x <> ";") $
      [ case clientPagesLoaderOptions.absoluteJsDepsPath of
             Nothing -> ""
             Just absoluteJsDepsPath -> "require(" <> printPathPosixSandboxAny absoluteJsDepsPath <> ")"
      , String.joinWith ""
          [ "(window.__PAGE_CACHE_BUS=window.__PAGE_CACHE_BUS||[]).push({ routeId:"
          , NextjsApp.Route.routeIdToString $ Lens.view NextjsApp.Route._routeToRouteIdIso $ route
          , ", page: require("
          , printPathPosixSandboxAny clientPagesLoaderOptions.absoluteCompiledPagePursPath
          , ").page })"
          ]
      ]

  source' <- Node.Buffer.fromString source Node.Encoding.UTF8

  pure { source: source' }

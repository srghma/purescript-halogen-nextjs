module NextjsWebpack.IsomorphicClientPagesLoader (default, optionsCodec) where

import Control.Promise
import Data.Codec
-- | import Data.Newtype
import Effect.Uncurried
import Foreign
import LoaderUtils
import ModuleName
import Pathy
import Pathy
import Protolude
import Webpack.Loader
import Data.Argonaut.Core (Json)
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Codec.Argonaut (JsonCodec, JsonDecodeError(..))
import Data.Codec.Argonaut as Data.Codec.Argonaut
import Data.Codec as Codec
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
import Node.URL (Query)
import Node.URL as Node.URL
import Foreign (Foreign)
import Foreign as Foreign
import Foreign.NullOrUndefined as Foreign.NullOrUndefined
import Foreign.Object (Object)
import Foreign.Object as Object
import Unsafe.Coerce (unsafeCoerce)
import NodeUrlExtra

type QueryCodec a
  = BasicCodec (Either JsonDecodeError) Query a

type Options
  = { absoluteCompiledPagePursPath :: Path Abs File -- e.g. ".../output/Foo/index.js"
    , absoluteJsDepsPath :: Maybe (Path Abs File) -- e.g. ".../client/Pages/Foo.deps.js" or null
    , route :: Route
    }

routeIdCodec ∷ BasicCodec (Either JsonDecodeError) String RouteId
routeIdCodec = basicCodec dec enc
  where
  dec :: String -> Either JsonDecodeError RouteId
  dec s = NextjsApp.Route.stringToMaybeRouteId s # note (Named "routeId" MissingValue)

  enc :: RouteId -> String
  enc = NextjsApp.Route.routeIdToString

routeCodec ∷ BasicCodec (Either JsonDecodeError) String Route
routeCodec = dimap (Lens.view NextjsApp.Route._routeToRouteIdIso) (Lens.review NextjsApp.Route._routeToRouteIdIso) routeIdCodec

absFileCodec ∷
  { parser :: Parser
  , printer :: Printer
  , sandboxer :: Path Abs File -> SandboxedPath Abs File
  } ->
  BasicCodec (Either JsonDecodeError) String (Path Abs File)
absFileCodec config = basicCodec dec enc
  where
  dec :: String -> Either JsonDecodeError (Path Abs File)
  dec s = parseAbsFile config.parser s # note (Named "absFile" MissingValue)

  enc :: Path Abs File -> String
  enc = printPath config.printer <<< config.sandboxer

absFileCodecPosixRoot :: BasicCodec (Either JsonDecodeError) String (Path Abs File)
absFileCodecPosixRoot =
  absFileCodec
    { parser: posixParser
    , printer: posixPrinter
    , sandboxer: sandboxAny
    }

optionsCodec :: QueryCodec Options
optionsCodec = basicCodec (fromQuery >>> dec) (enc >>> toQuery)
  where
  lookup name obj = Object.lookup name obj # note (AtKey name MissingValue)

  dec ::
    Object String ->
    Either JsonDecodeError
      { absoluteCompiledPagePursPath :: Path Abs File
      , absoluteJsDepsPath :: Maybe (Path Abs File)
      , route :: Route
      }
  dec obj = do
    (absoluteCompiledPagePursPath :: String) <- lookup "absoluteCompiledPagePursPath" obj
    let
      (absoluteJsDepsPath :: Maybe String) = Object.lookup "absoluteJsDepsPath" obj
    (route :: String) <- lookup "route" obj
    (absoluteCompiledPagePursPath' :: Path Abs File) <- Codec.decode absFileCodecPosixRoot absoluteCompiledPagePursPath
    (absoluteJsDepsPath' :: Maybe (Path Abs File)) <- traverse (Codec.decode absFileCodecPosixRoot) absoluteJsDepsPath
    (route' :: Route) <- Codec.decode routeCodec route
    pure
      { absoluteCompiledPagePursPath: absoluteCompiledPagePursPath'
      , absoluteJsDepsPath: absoluteJsDepsPath'
      , route: route'
      }

  enc ::
    { absoluteCompiledPagePursPath :: Path Abs File
    , absoluteJsDepsPath :: Maybe (Path Abs File)
    , route :: Route
    } ->
    Object String
  enc obj =
    Object.fromFoldable
      $ Array.catMaybes
          [ Just $ "absoluteCompiledPagePursPath" /\ Codec.encode absFileCodecPosixRoot obj.absoluteCompiledPagePursPath
          , map (\x -> "absoluteJsDepsPath" /\ Codec.encode absFileCodecPosixRoot x) obj.absoluteJsDepsPath
          , Just $ "route" /\ Codec.encode routeCodec obj.route
          ]

-- | "default" is a magic word
-- | https://github.com/webpack/loader-runner/blob/cebc687275edc688a5d8cf0d7c9a2be34c67fa4d/lib/loadLoader.js#L45
-- | https://github.com/webpack/webpack/issues/11581#issuecomment-704200033
default :: Loader
default =
  mkAsyncLoader \context buffer ->
    liftEffect do
      (query :: Query) <- getOptions context
      options <- case Codec.decode optionsCodec query of
        Left decodeError -> throwError $ error $ Data.Codec.Argonaut.printJsonDecodeError decodeError
        Right options -> pure options
      let
        source =
          String.joinWith "" <<< map (\x -> x <> ";")
            $ Array.catMaybes
                [ flip map options.absoluteJsDepsPath $ \absoluteJsDepsPath -> "require(" <> show (printPathPosixSandboxAny absoluteJsDepsPath) <> ")"
                , Just
                    $ String.joinWith ""
                        [ "(window.__PAGE_CACHE_BUS=window.__PAGE_CACHE_BUS||[]).push({ routeId: "
                        , show $ NextjsApp.Route.routeIdToString $ Lens.view NextjsApp.Route._routeToRouteIdIso $ options.route
                        , ", page: require("
                        , show $ printPathPosixSandboxAny options.absoluteCompiledPagePursPath
                        , ").page })"
                        ]
                ]
      source' <- Node.Buffer.fromString source Node.Encoding.UTF8
      pure { source: source' }

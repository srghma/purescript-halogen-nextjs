module NextjsWebpack.BuildManifestPlugin where

import Control.Promise
import Data.Function.Uncurried
import Effect.Uncurried
import NextjsApp.Manifest.ServerBuildManifest
import NextjsApp.Route
import Pathy
import Protolude
import Protolude
import Webpack.FFI
import Webpack.Types

import Data.Argonaut.Core (Json)
import Data.Argonaut.Core as Argonaut
import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Encode as ArgonautCodecs
import Data.Array as Array
import Data.String.Utils as String
import Foreign (Foreign)
import Foreign as Foreign
import Foreign.Object (Object)
import Foreign.Object as Object
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import Record.Extra as Record.Extra
import Record.ExtraSrghma as Record.ExtraSrghma
import Type.Prelude (RProxy(..))

type EntrypointsRow a = RouteIdMappingRow' a ( main :: a )

decodePages :: Object WebpackEntrypont -> Either String { | EntrypointsRow WebpackEntrypont }
decodePages obj = Record.Extra.sequenceRecord $ Record.ExtraSrghma.mapIndex doWork (RProxy :: forall type_ . RProxy (EntrypointsRow type_))
  where
    doWork s =
      case Object.lookup s obj of
           Just x -> Right x
           Nothing -> traceWithoutInspect { s, obj } (const (Left $ "cannot find " <> s))

toCssAndJs :: WebpackEntrypont -> Effect { css :: Array String, js :: Array String }
toCssAndJs entrypoint = do
  -- | name <- runEffectFn1 webpackEntrypontName entrypoint

  (files :: Array String) <- runEffectFn1 webpackEntrypontGetFiles entrypoint

  let { yes: css, no: nonCss } = Array.partition (String.endsWith ".css") files

  let { yes: js, no: other } = Array.partition (String.endsWith ".js") nonCss

  when (Array.null other) (throwError $ error $ "unknown files: " <> show other)

  pure { css, js }

-- from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts
buildManifestPlugin :: WebpackPluginInstance
buildManifestPlugin = mkPluginSync "BuildManifestPlugin" \compilation -> do
  (entrypointValues :: Object WebpackEntrypont) <- runEffectFn1 compilationGetEntrypoints compilation

  (entrypointValues' :: { | EntrypointsRow WebpackEntrypont }) <-
    decodePages entrypointValues #
      case _ of
           Right x -> pure x
           Left errorString -> throwError $ error errorString

  (entrypointValues'' :: { | EntrypointsRow NextjsApp.Manifest.PageManifest.PageManifest }) <- Record.Extra.sequenceRecord (Record.Extra.mapRecord toCssAndJs entrypointValues')

  let main /\ pages = Record.ExtraSrghma.pop (SProxy :: SProxy "main") entrypointValues''

  let (manifest :: BuildManifest) =
        { pages
        , main
        }

  let (json :: Json) = ArgonautCodecs.encodeJson manifest

  traceM json

  runEffectFn3 compilationSetAsset compilation "build-manifest.json" (rawSource $ Argonaut.stringifyWithIndent 2 json)

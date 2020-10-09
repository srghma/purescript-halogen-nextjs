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
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.String.Utils as String
import Favicons (FavIconResponse)
import Foreign (Foreign)
import Foreign as Foreign
import Foreign.JsMap (JsMap)
import Foreign.JsMap as JsMap
import Foreign.Object (Object)
import Foreign.Object as Object
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import Record.Extra as Record.Extra
import Record.ExtraSrghma as Record.ExtraSrghma
import Type.Prelude (RProxy(..))
import Unsafe.Coerce (unsafeCoerce)

type EntrypointsRow a = RouteIdMappingRow' a ( main :: a )

decodePages :: JsMap String WebpackEntrypont -> Effect { | EntrypointsRow WebpackEntrypont }
decodePages obj = Record.Extra.sequenceRecord $ Record.ExtraSrghma.mapIndex doWork (RProxy :: forall type_ . RProxy (EntrypointsRow type_))
  where
    doWork s = JsMap.get s obj >>=
      case _ of
           Just x -> pure x
           Nothing -> throwError $ error $ "cannot find " <> s

toCssAndJs :: String -> WebpackEntrypont -> Effect { css :: Array String, js :: Array String }
toCssAndJs publicPath entrypoint = do
  -- | name <- runEffectFn1 webpackEntrypontName entrypoint

  (files :: Array String) <- runEffectFn1 webpackEntrypontGetFiles entrypoint <#> map (publicPath <> _)

  let { yes: css, no: nonCss } = Array.partition (String.endsWith ".css") files

  let { yes: js, no: other } = Array.partition (String.endsWith ".js") nonCss

  when (not $ Array.null other) (throwError $ error $ "unknown files: " <> show other)

  pure { css, js }

type PluginOptions = { favIconResponse :: FavIconResponse }

-- from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts
buildManifestPlugin :: PluginOptions -> WebpackPluginInstance
buildManifestPlugin pluginOptions = mkPluginSync "BuildManifestPlugin" \compilation -> do
  (entrypointValues :: JsMap String WebpackEntrypont) <- runEffectFn1 compilationGetEntrypoints compilation

  let (publicPath :: Nullable String) = (unsafeCoerce compilation).options.output.publicPath

  publicPath' <-
    case Nullable.toMaybe publicPath of
         Just x -> pure x
         Nothing -> throwError $ error $ "no publicPath"

  (entrypointValues' :: { | EntrypointsRow WebpackEntrypont }) <- decodePages entrypointValues

  (entrypointValues'' :: { | EntrypointsRow NextjsApp.Manifest.PageManifest.PageManifest }) <- Record.Extra.sequenceRecord (Record.Extra.mapRecord (toCssAndJs publicPath') entrypointValues')

  let main /\ pages = Record.ExtraSrghma.pop (SProxy :: SProxy "main") entrypointValues''

  let (manifest :: BuildManifest) =
        { pages
        , main
        , faviconsHtml: pluginOptions.favIconResponse.html
        }

  let (json :: Json) = ArgonautCodecs.encodeJson manifest

  runEffectFn3 compilationSetAsset compilation "build-manifest.json" (rawSource $ Argonaut.stringifyWithIndent 2 json)

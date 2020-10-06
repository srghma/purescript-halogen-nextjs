module NextjsWebpack.BuildManifestPlugin where

import Protolude
import NextjsApp.Manifest.ServerBuildManifest

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Foreign.Object (Object)
import Foreign.Object as Object
import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Encode as ArgonautCodecs
import Data.Argonaut.Core (Json, stringifyWithIndent)
import Pathy
import Webpack.Types
import Webpack.FFI
import Data.Function.Uncurried

-- from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts
buildManifestPlugin :: WebpackPluginInstance
buildManifestPlugin = mkPluginSync "BuildManifestPlugin" \compilation -> do
  (entrypointValues :: Object WebpackEntrypont) <- runEffectFn1 compilationGetEntrypoints compilation

  -- | const pages = R.map(
  -- |   entrypoint => {
  -- |     const name = entrypoint.name
  -- |     const files = entrypoint.getFiles()

  -- |     const [css, nonCss] = R.partition(R.test(/\.css$/), files)
  -- |     const [js, other] = R.partition(R.test(/\.js$/), nonCss)

  -- |     if (!RA.isEmptyArray(other)) {
  -- |       console.log(other)
  -- |       throw new Error('should be empty')
  -- |     }

  -- |     return [
  -- |       name,
  -- |       {
  -- |         css: R.map((x) => "/" + x, css),
  -- |         js: R.map((x) => "/" + x, js)
  -- |       },
  -- |     ]
  -- |   },
  -- |   Array.from(compilation.entrypoints.values())
  -- | )

  -- | const pages_ = R.fromPairs(pages)

  -- | const assetMap = {
  -- |   pages: R.dissoc('main', pages_),
  -- |   main: R.prop('main', pages_)
  -- | }

  let (manifest :: BuildManifest) = undefined

  let (json :: Json) = ArgonautCodecs.encodeJson manifest

  runEffectFn3 compilationSetAsset compilation "build-manifest.json" (rawSource $ stringifyWithIndent 2 json)

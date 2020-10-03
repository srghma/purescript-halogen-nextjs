module Webpack.BuildManifestPlugin where

webpackEntrypontName :: WebpackEntrypont -> Effect String

webpackEntrypontGetFiles :: WebpackEntrypont -> Effect (Array String)

rawSource :: String -> RawSource

printBuildManifest ::

webpackSetAsset :: Compilation -> String -> RawSource -> Unit

foreign import mkBuildManifestPlugin :: StrMap WebpackEntrypont -> Effect Unit

class BuildManifestPlugin {
  constructor(options) { }

  apply(compiler) {
    compiler.hooks.emit.tapAsync(
      'BuildManifest',
      (compilation, callback) => {
        const pages = R.map(
          entrypoint => {
            const name = entrypoint.name
            const files = entrypoint.getFiles()

            const [css, nonCss] = R.partition(R.test(/\.css$/), files)
            const [js, other] = R.partition(R.test(/\.js$/), nonCss)

            if (!RA.isEmptyArray(other)) {
              console.log(other)
              throw new Error('should be empty')
            }

            return [
              name,
              {
                css: R.map((x) => "/" + x, css),
                js: R.map((x) => "/" + x, js)
              },
            ]
          },
          Array.from(compilation.entrypoints.values())
        )

        const pages_ = R.fromPairs(pages)

        const assetMap = {
          pages: R.dissoc('main', pages_),
          main: R.prop('main', pages_)
        }

        compilation.assets['build-manifest.json'] = new RawSource(
          JSON.stringify(assetMap, null, 2)
        )

        callback()
      }
    )
  }
}

module.exports = BuildManifestPlugin


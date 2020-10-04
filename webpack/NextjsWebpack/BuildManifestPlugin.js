// from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts

exports.mkBuildManifestPlugin = function(doWork) {
  class BuildManifestPlugin {
    apply(compiler) {
      compiler.hooks.emit.tapAsync(
        'BuildManifest',
        (compilation, callback) => {
          doWork(compilation)

          callback()
        }
      )
    }
  }

  return new BuildManifestPlugin()
}

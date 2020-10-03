// from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts

import { RawSource } from 'webpack-sources'

exports.mkBuildManifestPlugin = function(doWork) {
  return class BuildManifestPlugin {
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
}

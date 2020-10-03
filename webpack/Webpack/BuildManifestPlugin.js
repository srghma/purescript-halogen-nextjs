// from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts

exports.webpackEntrypontName = function(entrypoint) { return entrypoint.name }

exports.webpackEntrypontGetFiles = function(entrypoint) { return entrypoint.getFiles() }

exports.rawSource = function(string) {
  return new require('webpack-sources').RawSource(string)
}

exports.compilationSetAsset = function(compilation, name, rawSource) { compilation[name] = rawSource }

exports.compilationGetEntrypoints = function(compilation) { return compilation.entrypoints }

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

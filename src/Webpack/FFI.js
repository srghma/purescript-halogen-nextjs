exports.webpackEntrypontName = function(entrypoint) { return entrypoint.name }

exports.webpackEntrypontGetFiles = function(entrypoint) { return entrypoint.getFiles() }

exports.rawSource = function(string) {
  return new require('webpack-sources').RawSource(string)
}

exports.compilationSetAsset = function(compilation, name, rawSource) { compilation[name] = rawSource }

exports.compilationGetEntrypoints = function(compilation) { return compilation.entrypoints }

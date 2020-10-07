exports.webpackEntrypontName = function(entrypoint) { return entrypoint.name }

exports.webpackEntrypontGetFiles = function(entrypoint) { return entrypoint.getFiles() }

exports.rawSource = function(string) {
  return new (require('webpack-sources').RawSource)(string)
}

exports.compilationSetAsset = function(compilation, name, rawSource) { compilation[name] = rawSource }

exports.compilationGetEntrypoints = function(compilation) {
  // console.log('compilation', compilation.entrypoints)
  return compilation.entrypoints
}

exports.mkPlugin = function(pluginName, doWork) {
  // how to define class name dynamically https://www.reddit.com/r/javascript/comments/b56f7z/dynamic_class_name_classname0/ejbl5fe?utm_source=share&utm_medium=web2x&context=3
  //
  // eq to
  //
  // class ClassName {
  //   apply(compiler) {
  //     compiler.hooks.emit.tapAsync(pluginName, doWork)
  //   }
  // }

  const refForDynamicName = {
    [pluginName]: class {
        apply(compiler) {
          compiler.hooks.emit.tapAsync(pluginName, doWork)
        }
    }
  }

  return new (refForDynamicName[pluginName])()
}

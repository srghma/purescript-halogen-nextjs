// from https://github.com/vercel/next.js/blob/e125d905a0/packages/next/build/webpack/plugins/build-manifest-plugin.ts

exports.mkPlugin = function(pluginName, doWork) {
  // how to define class name dynamically https://www.reddit.com/r/javascript/comments/b56f7z/dynamic_class_name_classname0/ejbl5fe?utm_source=share&utm_medium=web2x&context=3

  const refForDynamicName = {}

  refForDynamicName[pluginName] = class {
    apply(compiler) {
      compiler.hooks.emit.tapAsync(pluginName (compilation, callback) => doWork(compilation, callback))
    }
  }

  const pluginClass = refForDynamicName[pluginName]

  return new pluginClass()
}

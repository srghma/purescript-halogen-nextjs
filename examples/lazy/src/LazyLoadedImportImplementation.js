exports.lazyLoadedImport = function() {
  var x = import(
    './LazyLoaded.purs'
  )
  console.log(x)
  return x
}

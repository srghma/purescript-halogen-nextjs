const chokidar = require('chokidar')

exports._watch = function({ files, onAll }) {
  const watcher = chokidar.watch(files)

  watcher.on('all', function(event, path) {
    onAll(path)
  })

  return function() {
    watcher.close()
  }
}

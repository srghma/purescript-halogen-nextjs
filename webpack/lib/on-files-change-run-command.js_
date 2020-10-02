const chokidar = require('chokidar')
const childProcessPromise = require('child-process-promise')

export default function({ files, command, commandArgs }) {
  const watcher = chokidar.watch(files)

  watcher.on('all', (_event, _path) => {
    childProcessPromise
      .spawn(command, commandArgs, { stdio: ['ignore', 'inherit', 'inherit'] })
  })
}

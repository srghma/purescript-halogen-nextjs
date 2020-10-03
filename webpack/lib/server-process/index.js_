const childProcess = require('child_process')

const isWorking = (serverProcess) =>
  serverProcess.exitCode == null && // the child exited on its own
  serverProcess.signalCode == null // signal by which the child process was terminated, by us for example

module.exports = function spawnServerProcess({ command, onProcessEndsWithoutError, onProcessEndsWithError }) {
  const serverProcess = childProcess.spawn(
    command.head,
    command.tail,
    {
      stdio: ['pipe', 'inherit', 'inherit'],
    }
  )

  // serverProcess.on('close', (code, signal) => { console.log(`child process closed all stdin with code ${code}`) })

  serverProcess.on('exit', (code, signal) => {
    console.log(`[SERVER] Server exited with exitCode ${serverProcess.exitCode}, killed with signalCode ${serverProcess.signalCode}`)

    if (code) {
      if (code === 0) {
        onProcessEndsWithoutError()
      } else {
        onProcessEndsWithError()
      }
    }

    onProcessEndsWithoutError() // if we killed it - then there is no error
  })

  return {
    serverProcess, // ref
    kill: () => {
      if (isWorking(serverProcess)) {
        console.log(`[SERVER] Killing server`)

        serverProcess.kill('SIGKILL')
      }
    },
  }
}

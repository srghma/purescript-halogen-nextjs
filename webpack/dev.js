import * as R from 'ramda'
import * as RA from 'ramda-adjunct'
import webpack from 'webpack'
import * as path from 'path'
import chalk from 'chalk'

import createConfig from './config'
import webpackGetError from './lib/webpackGetError'
import fileExistsAndIsNonEmpty from './lib/fileExistsAndIsNonEmpty'

const serverPort = 3000

let serverProcessState

require('webpack-spago-loader/watcher-job')({
  additionalWatchGlobs: ['app/**/*.css', 'src/**/*.css'],
  options: require('./lib/spago-options'),
  onStart: () => {
    console.log(`onStart: killing ${serverProcessState && serverProcessState.serverProcess}`)
    // stop webpack if it is running (you cannot)

    // stop server if it is running

    serverProcessState && serverProcessState.kill()
  },
  onError: () => {
    console.log(`onError: ${serverProcessState && serverProcessState.serverProcess}`)
    // do nothing, all was already handled in "started_compiling"
  },
  onSuccess: async () => {
    console.log(`onSuccess: ${serverProcessState && serverProcessState.serverProcess}`)

    // wait webpack to end (you cannot)

    // wait server to end

    // start webpack

    const commonSettings = { production: false }

    const configs = await Promise.all([
      createConfig(R.mergeAll([commonSettings, { target: 'browser' }])),
      createConfig(R.mergeAll([commonSettings, { target: 'server' }]))
    ])

    const compiler = webpack(configs)

    console.log('[webpack] Compiling...')

    compiler.run((err, stats) => {
      const error = webpackGetError(err, stats)

      if (error) {
        console.warn(chalk.keyword('orange')(error))
        return
      }

      // start server

      const clientConfig = configs[0]
      const serverConfig = configs[1]

      const serverPath = path.resolve(serverConfig.output.path, 'main.js') // hardcoded, dont know how to find (serverConfig.output.filename doesnt help)

      if(!fileExistsAndIsNonEmpty(serverPath)) {
        console.log(`[SERVER] file doesn't exist ${serverPath}`)
        return null
      }

      console.log(`onSuccess: starting ${serverProcessState && serverProcessState.serverProcess}`)

      const command = {
        head: "node",
        tail: [
          "--trace-deprecation",
          serverPath,
          "--port",
          serverPort.toString(),
          "--root-path",
          clientConfig.output.path,
        ]
      }

      serverProcessState = require('./lib/server-process')({
        command,
        onProcessEndsWithoutError: () => { },
        onProcessEndsWithError: () => { },
      })
    })
  }
})

process.on('exit', function() {
  // kill zombie process
  serverProcessState && serverProcessState.kill()
})

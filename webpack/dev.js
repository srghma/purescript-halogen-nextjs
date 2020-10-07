const RA = require('ramda-adjunct')
const path = require('path')

function webpackGetError(err, stats) {
  if (err) {
    return err // this is error object
  }

  for (let stat of stats.stats) {
    const errors = stat.compilation.errors

    if (!RA.isEmptyArray(errors)) {
      return errors // this is array
    }
  }
}

function fileExistsAndIsNonEmpty(path) {
  try {
    const stat = require('fs').statSync(path)

    return stat.isFile() && stat.size !== 0
  } catch (e) {
    return false
  }
}

const chokidar = require('chokidar')
const childProcessPromise = require('child-process-promise')

const onFilesChangeRunCommand = function({ files, command, commandArgs }) {
  const watcher = chokidar.watch(files)

  watcher.on('all', (_event, _path) => {
    childProcessPromise.spawn(command, commandArgs, { stdio: ['ignore', 'inherit', 'inherit'] })
  })
}

const spagoDhall = './spago.dhall'

const spagoOptions = {
  output:    require('webpack-spago-loader/lib/getAbsoluteOutputDirFromSpago')(spagoDhall),
  pursFiles: require('webpack-spago-loader/lib/getSourcesFromSpago')(spagoDhall),

  compiler: 'psa',
  // note that warnings are shown only when file is recompiled, delete output folder to show all warnings
  compilerOptions: {
    censorCodes: [
      'ImplicitQualifiedImport',
      'UnusedImport',
      'ImplicitImport',
    ].join(','),
    // strict: true
  }
}

const serverPort = 3000

let serverProcessState

onFilesChangeRunCommand({
  files: ['app/**/*.scss'],
  command: 'generate-halogen-css-modules',
  commandArgs: ['-d', './app'],
})

require('webpack-spago-loader/watcher-job')({
  additionalWatchGlobs: ['app/**/*.scss', 'src/**/*.scss'],
  options: spagoOptions,
  onStart: () => {},
  onError: () => {},
  onSuccess: async () => {
    // clear cache
    for (const cachePath in require.cache) {
      if (
        cachePath.startsWith(spagoOptions.output)
      ) {
        console.log('clearing cachePath', cachePath)
        delete require.cache[cachePath]
      }
    }

    console.log(`onSuccess: ${serverProcessState && serverProcessState.serverProcess}`)

    // wait webpack to end (you cannot)

    // wait server to end

    // start webpack

    require(spagoOptions.output + '/NextjsWebpack.Entries.Dev/index.js').runWebpack({
      onSuccess: function({ serverConfig, clientConfig }) {
        console.log('[mywebpack] Compiling...')

        serverProcessState && serverProcessState.kill()

        const serverPath = path.resolve(serverConfig.output.path, 'main.js') // hardcoded, dont know how to find (serverConfig.output.filename doesn't help)

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

        serverProcessState = require('./server-process')({
          command,
          onProcessEndsWithoutError: () => { },
          onProcessEndsWithError: () => { },
        })
      }
    })()
  }
})

process.on('exit', function() {
  // kill zombie process
  serverProcessState && serverProcessState.kill()
})

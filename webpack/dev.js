const RA = require('ramda-adjunct')
const path = require('path')

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

const cleanupCssModulesGenerator = require(spagoOptions.output + '/NextjsWebpack.Utils.OnFilesChangedRunCommand/index.js').onFilesChangedRunCommand({
  files: ['app/**/*.scss'],
  command: [ 'generate-halogen-css-modules', '-d', './app' ],
})()

const { spawnServer, cleanupServer } = require(spagoOptions.output + '/NextjsWebpack.Utils.OneServerATimeSpawner/index.js').oneServerATimeSpawner()

require('webpack-spago-loader/watcher-job')({
  // additionalWatchGlobs: ['app/**/*.scss', 'src/**/*.scss'],
  additionalWatchGlobs: [],
  options: spagoOptions,
  onStart: () => {},
  onError: () => {},
  onSuccess: async () => {
    // clear cache
    console.log('clearing cache')

    for (const cachePath in require.cache) {
      if (cachePath.startsWith(spagoOptions.output)) {
        delete require.cache[cachePath]
      }
    }

    // wait webpack to end (you cannot)

    // wait server to end

    // start webpack

    require(spagoOptions.output + '/NextjsWebpack.Entries.Dev/index.js').runWebpack({
      onSuccess: function({ serverConfig, clientConfig }) {
        const serverFilePath = path.resolve(serverConfig.output.path, 'main.js') // hardcoded, dont know how to find (serverConfig.output.filename doesn't help)

        spawnServer({
          serverFilePath,
          port: 3000,
          compiliedClientDirPath: clientConfig.output.path,
        })()
      }
    })()
  }
})

process.on('beforeExit', function() {
  console.log('cleaning up server and chokidar')
  cleanupCssModulesGenerator()
  cleanupServer()
})

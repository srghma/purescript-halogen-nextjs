module Webpack.FaviconsConfig where

import Protolude

import Data.Nullable (Nullable)

const faviconsAsync = util.promisify(favicons)

;(async function() {
  const source = path.join(root, 'purescript-favicon-black.svg') // Source image(s). `string`, `buffer` or array of `string`

  const response = await faviconsAsync(source, configuration);

  console.log(response)
  console.log(response)

  const commonSettings = { production: true }

  const configs = await Promise.all([
    createConfig(R.mergeAll([commonSettings, { target: 'browser' }])),
    createConfig(R.mergeAll([commonSettings, { target: 'server' }]))
  ])

  // console.log('configs', require('util').inspect(configs, { depth: null, maxArrayLength: Infinity, colors: true }))

  await require('webpack-spago-loader/build-job')(require('./lib/spago-options'))

  const compiler = webpack(configs)

  console.log('[webpack] Compiling...')

  compiler.run((err, stats) => {
    const error = webpackGetError(err, stats)

    if(error) {
      throw new Error(error)
    }
  })
})()

import * as R from 'ramda'
import * as RA from 'ramda-adjunct'
import webpack from 'webpack'

import createConfig from './config'
import webpackGetError from './lib/webpackGetError'

;(async function() {
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

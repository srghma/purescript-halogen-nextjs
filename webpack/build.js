import * as R from 'ramda'
import * as RA from 'ramda-adjunct'
import webpack from 'webpack'
import favicons from 'favicons'
import util from 'util'
import * as path from 'path'

import createConfig from './config'
import webpackGetError from './lib/webpackGetError'
import root from './lib/root'

const faviconsAsync = util.promisify(favicons)

;(async function() {
  const source = path.join(root, 'purescript-favicon-black.svg') // Source image(s). `string`, `buffer` or array of `string`

  const configuration = {
    path:         "/",                  // Path for overriding default icons path. `string`
    appName:      "Nextjs example app", // Your application's name. `string`
    appShortName: "Nextjs",             // Your application's short_name. `string`. Optional. If not set, appName will be used
    appDescription: "Example application for the best framework",                     // Your application's description. `string`
    developerName:               null,                // Your (or your developer's) name. `string`
    developerURL:                null,                // Your (or your developer's) URL. `string`
    dir:                         "auto",              // Primary text direction for name, short_name, and description
    lang:                        "en-US",             // Primary language for name and short_name
    background:                  "#fff",              // Background colour for flattened icons. `string`
    theme_color:                 "#fff",              // Theme color user for example in Android's task switcher. `string`
    appleStatusBarStyle:         "black-translucent", // Style for Apple status bar: "black-translucent", "default", "black". `string`
    display:                     "standalone",        // Preferred display mode: "fullscreen", "standalone", "minimal-ui" or "browser". `string`
    orientation:                 "any",               // Default orientation: "any", "natural", "portrait" or "landscape". `string`
    scope:                       "/",                 // set of URLs that the browser considers within your app
    start_url:                   "/",                 // Start URL when launching the application from a device. `string`
    version:                     "1.0",               // Your application's version string. `string`
    logging:                     false,               // Print logs to console? `boolean`
    pixel_art:                   false,               // Keeps pixels "sharp" when scaling up, for pixel art.  Only supported in offline mode.
    loadManifestWithCredentials: false,               // Browsers don't send cookies when fetching a manifest, enable this to fix that. `boolean`
    icons: {
      // Platform Options:
      // - offset - offset in percentage
      // - background:
      //   * false - use default
      //   * true - force use default, e.g. set background for Android icons
      //   * color - set background for the specified icons
      //   * mask - apply mask in order to create circle icon (applied by default for firefox). `boolean`
      //   * overlayGlow - apply glow effect after mask has been applied (applied by default for firefox). `boolean`
      //   * overlayShadow - apply drop shadow after mask has been applied .`boolean`
      //
      android: false,              // Create Android homescreen icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      appleIcon: false,            // Create Apple touch icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      appleStartup: false,         // Create Apple startup images. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      coast: false,                // Create Opera Coast icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      favicons: true,             // Create regular favicons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      firefox: false,              // Create Firefox OS icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      windows: false,              // Create Windows 8 tile icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      yandex: false                // Create Yandex browser icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
    }
  }

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

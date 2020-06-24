import * as R from 'ramda'
import * as RA from 'ramda-adjunct'
import MiniCssExtractPlugin from 'mini-css-extract-plugin'
import * as path from 'path'
import * as webpack from 'webpack'

import root from '../lib/root'
import createClientPagesEntrypoints from '../config/createClientPagesEntrypoints'

// https://github.com/zeit/next.js/blob/450d4bd0f32a042fd452c81bc3850ec31306eab3/packages/next/next-server/lib/constants.ts#L35

const CLIENT_STATIC_FILES_RUNTIME_WEBPACK = 'webpack'

const totalPages = 5 // TODO

export default async function ({
  browser,
  watch,
  production,
  serverPort,
}) {
  const distDir = path.resolve(root, production ? '.dist' : '.dist-dev')
  const distOutputDir = path.resolve(distDir, browser ? 'client' : 'server')

  return {
    watch: watch,

    // watchOptions: { // doesnt work, still watches purs
    //   ignored: ['.purs', 'node_modules']
    // },

    target: browser ? 'web' : 'node',

    // mode: production ? 'production' : 'development',
    mode: 'development',

    // devServer: {
    //   // writeToDisk: true,
    //   // hot: true,
    //   // contentBase: path.join(root, '.dist-asdfadf'),
    //   // port: 4008,
    //   // stats: 'verbose', // doesnt work if webpack-dev-middleware is used
    //   // stats: 'errors-only', // doesnt work if webpack-dev-middleware is used
    //   // disableHostCheck: true, // That solved it
    //   // host: `localhost`,
    //   // port: hmrPort,
    //   // noInfo: true,
    //   // quiet: true,
    //   // clientLogLevel: 'silent'
    // },

    output: {
      path: distOutputDir,

      filename: browser ?
        (production ? '[name]-[contenthash].js' : '[name].js') :
        '[name].js',

      publicPath: '/',

      // publicPath: `http://localhost:${serverPort}/`,
      // hotUpdateMainFilename: `http://0.0.0.0:${hmrPort}/[hash].hot-update.json`

      // hotUpdateChunkFilename: 'hot-update.js',
      // hotUpdateMainFilename: 'hot-update.json',

      // hotUpdateChunkFilename: '[id].[hash].hot-update.js',
      // hotUpdateMainFilename: '[hash].hot-update.json',

      libraryTarget: browser ? 'var' : 'commonjs2',

      // This saves chunks with the name given via `import()`
      chunkFilename: browser
        ? `chunks/${production ? '[name]-[contenthash]' : '[name]'}.js`
        : undefined,
    },

    entry: browser ?
      R.mergeAll([await createClientPagesEntrypoints(), { main: path.resolve(root, "app", "client.entry.js") }]) :
      { main: path.resolve(root, "app", "server.entry.js") },

    node: browser ?
      false :
      {
        __dirname: false // possible values: false - runtime, true - during complilation, "mock" - "/"
      },

    bail: true,
    profile: false,
    stats: 'errors-only',
    // stats: 'verbose',
    // stats: {
    //   colors: true,
    // },

    context: root,

    devtool: browser ? (production ? false : 'eval') : false,

    module: {
      rules: require('./rules')()
    },

    resolve: {
      modules: [ 'node_modules' ],
      extensions: [ '.purs', '.js']
    },

    resolveLoader: {
      modules: [
        'node_modules',
      ],

      alias: R.pipe(
        R.map(loader => [loader, path.join(root, 'webpack', 'lib', loader)]),
        R.fromPairs,
      )([
        'isomorphic-client-pages-loader',
      ]),
    },

    plugins: RA.compact([
      // browser ? new MiniCssExtractPlugin() : null, // inline css doesnt work with ssr
      // TODO: per page https://github.com/webpack-contrib/mini-css-extract-plugin#extracting-css-based-on-entry
      new MiniCssExtractPlugin({
        // Options similar to the same options in webpackOptions.output
        // both options are optional
        filename: production ? 'css/[name].[hash].css' : 'css/[name].css',
        chunkFilename: production ? 'css/[id].[hash].css' : 'css/[id].css',
      }), // inline css doesnt work with ssr

      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(production ? "production" : "development"),
        'process.production': JSON.stringify(production),
        'process.browser': browser,

        ...(
          browser ? {} : {
            'ace': false, // for purescript-ace on node environment: dont throw 'undefined' exception, just make `var ace = false`
          }
        )
      }),

      (
        browser ?
        null :
        new webpack.ProvidePlugin({
          'XMLHttpRequest': 'xhr2', // on node - use 'xhr2' package
        })
      ),

      ...(
        (browser && !production) ?
        [
          new webpack.HotModuleReplacementPlugin(),
          new webpack.NoEmitOnErrorsPlugin()
        ] :
        []
      ),

      // TODO: fix for dev
      // (
      //   browser ?
      //   new (require('webpack-livereload-plugin'))({
      //     delay: 100,
      //     appendScriptTag: true,
      //   }) :
      //   null
      // ),

      (
        production ?
        new (require('clean-webpack-plugin').CleanWebpackPlugin)() :
        null
      ),

      (
        (process.env.BUNDLE_ANALYZE === "true" && browser) ?
        new (require('webpack-bundle-analyzer').BundleAnalyzerPlugin)({ analyzerPort: 8888 }) :
        null
      ),

      (
        browser ?
        new (require('../lib/build-manifest-plugin'))() :
        null
      ),

      // new (require('write-file-webpack-plugin'))({
      //   // exclude hot-update files
      //   test: /^(?!.*(hot)).*/,
      //   force: true,
      // }),

      // new webpack.LoaderOptionsPlugin({
      //   debug: true
      // }),

      // new (require('html-webpack-plugin'))({
      //   title: 'purescript-webpack-example',
      // }),
    ]),

    optimization: {
      noEmitOnErrors: true,

      splitChunks: browser ?
        (production ? require('./splitChunksConfig').prod({ totalPages }) : require('./splitChunksConfig').dev) :
        false,

      nodeEnv: false,

      runtimeChunk: browser // extract webpack runtime to separate module, e.g. "/runtime/webpack-xxxxx.js"
        ? { name: CLIENT_STATIC_FILES_RUNTIME_WEBPACK }
        : false,

      // minimize: production && browser,
      // minimizer: [
      //   // Minify JavaScript
      //   new TerserPlugin({
      //     extractComments: false,
      //     cache: path.join(distDir, 'cache', 'next-minifier'),
      //     parallel: config.experimental.cpus || true,
      //     terserOptions,
      //   }),
      //   // Minify CSS
      //   new CssMinimizerPlugin({
      //     postcssOptions: {
      //       map: {
      //         // `inline: false` generates the source map in a separate file.
      //         // Otherwise, the CSS file is needlessly large.
      //         inline: false,
      //         // `annotation: false` skips appending the `sourceMappingURL`
      //         // to the end of the CSS file. Webpack already handles this.
      //         annotation: false,
      //       },
      //     },
      //   }),
    },
  }
}

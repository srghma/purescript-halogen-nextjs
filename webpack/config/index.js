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

const onTarget = ({ target, onBrowser, onServer, onMobile }) => {
  switch (target) {
    case 'browser':
      if (onBrowser) { return onBrowser() };
      break;
    case 'server':
      if (onServer) { return onServer() };
      break;
    case 'mobile':
      if (onMobile) { return onMobile() };
      break;
    default:
      throw new Error('unknown target', target);
  }
}

export default async function ({
  target,
  watch,
  production,
  serverPort,
}) {
  return {
    watch: watch,

    // watchOptions: { // doesnt work, still watches purs
    //   ignored: ['.purs', 'node_modules']
    // },

    target: onTarget({
      target,
      onBrowser: () => 'web',
      onServer: () => 'node',
      onMobile: () => 'web',
    }),

    mode: production ? 'production' : 'development',

    ...(
      onTarget({
        target,
        onBrowser: () => undefined,
        onServer: () => undefined,
        onMobile: () => ({
          devServer: {
            hot: false,
          },
        }),
      })
    ),

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
      path: onTarget({
        target,
        onBrowser: () => path.resolve(root, production ? '.dist' : '.dist-dev', 'client'),
        onServer: () => path.resolve(root, production ? '.dist' : '.dist-dev', 'server' ),
        onMobile: () => path.resolve(root, 'www'),
      }),

      filename: onTarget({
        target,
        onBrowser: () => production ? '[name]-[contenthash].js' : '[name].js',
        onServer: () => '[name].js',
        onMobile: () => 'index.bundle.js',
      }),

      publicPath: onTarget({
        target,
        onBrowser: () => '/',
        onServer: () => '/',
        onMobile: () => './', // from https://github.com/jantimon/html-webpack-plugin/issues/488
      }),

      // publicPath: `http://localhost:${serverPort}/`,
      // hotUpdateMainFilename: `http://0.0.0.0:${hmrPort}/[hash].hot-update.json`

      // hotUpdateChunkFilename: 'hot-update.js',
      // hotUpdateMainFilename: 'hot-update.json',

      // hotUpdateChunkFilename: '[id].[hash].hot-update.js',
      // hotUpdateMainFilename: '[hash].hot-update.json',

      libraryTarget: onTarget({
        target,
        onBrowser: () => 'var',
        onServer: () => 'commonjs2',
        onMobile: () => 'var',
      }),

      // This saves chunks with the name given via `import()`
      chunkFilename: onTarget({
        target,
        onBrowser: () => `chunks/${production ? '[name]-[contenthash]' : '[name]'}.js`,
        onServer: () => undefined,
        onMobile: () => undefined,
      }),
    },

    entry: await onTarget({
      target,
      onBrowser: async () => R.mergeAll([
        await createClientPagesEntrypoints(path.resolve(root, "app", "Nextjs", "Pages")),
        { main: path.resolve(root, "app", "client.entry.js") }]
      ),
      onServer: () => ({ main: path.resolve(root, "app", "server.entry.js") }),
      onMobile: () => ({ main: path.resolve(root, "app", "mobile.entry.js") }),
    }),

    node: onTarget({
      target,
      onBrowser: () => false,
      onServer: () => ({
        __dirname: false // possible values: false - runtime, true - during complilation, "mock" - "/"
      }),
      onMobile: () => false,
    }),

    bail: true,
    profile: false,
    stats: 'errors-only',
    // stats: 'verbose',
    // stats: {
    //   colors: true,
    // },

    context: root,

    devtool: onTarget({
      target,
      onBrowser: () => production ? false : 'eval',
      onServer: () => false,
      onMobile: () => production ? false : 'eval',
    }),

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

      alias: onTarget({
        target,
        onBrowser: () => ({
          'isomorphic-client-pages-loader': path.join(root, 'webpack', 'lib', 'isomorphic-client-pages-loader')
        }),
        onServer: () => undefined,
        onMobile: () => undefined,
      }),
    },

    plugins: RA.compact([
      // target === 'browser' ? new MiniCssExtractPlugin() : null, // inline css doesnt work with ssr
      // TODO: per page https://github.com/webpack-contrib/mini-css-extract-plugin#extracting-css-based-on-entry
      new MiniCssExtractPlugin({
        // Options similar to the same options in webpackOptions.output
        // both options are optional
        filename: onTarget({
          target,
          onBrowser: () => production ? 'css/[name].[hash].css' : 'css/[name].css',
          onServer: () => production ? 'css/[name].[hash].css' : 'css/[name].css',
          onMobile: () => 'css/index.css',
        }),

        chunkFilename: onTarget({
          target,
          onBrowser: () => production ? 'css/[id].[hash].css' : 'css/[id].css',
          onServer: () => production ? 'css/[id].[hash].css' : 'css/[id].css',
          onMobile: () => false,
        }),
      }),

      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(production ? "production" : "development"),
        'process.production': JSON.stringify(production),
        'process.target': target,

        ...(
          target === 'server' ?
            {
              'ace': false, // for purescript-ace on node environment: dont throw 'undefined' exception, just make `var ace = false`
            } :
            undefined
        )
      }),

      (
        target === 'server' ?
        new webpack.ProvidePlugin({
          'XMLHttpRequest': 'xhr2', // on node - use 'xhr2' package
        }) :
        undefined
      ),

      new webpack.NoEmitOnErrorsPlugin(),

      new (require('clean-webpack-plugin').CleanWebpackPlugin)(),

      (
        (process.env.BUNDLE_ANALYZE === "true" && target === 'browser') ?
        new (require('webpack-bundle-analyzer').BundleAnalyzerPlugin)({ analyzerPort: 8888 }) :
        null
      ),

      (
        target === 'browser' ?
        new (require('../lib/build-manifest-plugin'))() :
        null
      ),

      (
        target === 'mobile' ?
        new (require('html-webpack-plugin'))({
          title: 'Purescript Nextjs',
          template: path.resolve(root, 'cordova-template-index.html'),
          minify: false,
        }) :
        null
      ),

      // TODO: fix for dev
      // (
      //   target === 'browser' ?
      //   new (require('webpack-livereload-plugin'))({
      //     delay: 100,
      //     appendScriptTag: true,
      //   }) :
      //   null
      // ),

      // new (require('write-file-webpack-plugin'))({
      //   // exclude hot-update files
      //   test: /^(?!.*(hot)).*/,
      //   force: true,
      // }),

      // new webpack.LoaderOptionsPlugin({
      //   debug: true
      // }),
    ]),

    optimization: {
      noEmitOnErrors: true,

      splitChunks: target === 'browser' ?
        (production ? require('./splitChunksConfig').prod({ totalPages }) : require('./splitChunksConfig').dev) :
        false,

      nodeEnv: false,

      runtimeChunk: target === 'browser' // extract webpack runtime to separate module, e.g. "/runtime/webpack-xxxxx.js"
        ? { name: CLIENT_STATIC_FILES_RUNTIME_WEBPACK }
        : false,

      // minimize: production && target === 'browser',

      // minimizer: production ? [
      //   new (require('terser-webpack-plugin'))(),

      //   // Minify CSS
      //   // new CssMinimizerPlugin({
      //   //   postcssOptions: {
      //   //     map: {
      //   //       // `inline: false` generates the source map in a separate file.
      //   //       // Otherwise, the CSS file is needlessly large.
      //   //       inline: false,
      //   //       // `annotation: false` skips appending the `sourceMappingURL`
      //   //       // to the end of the CSS file. Webpack already handles this.
      //   //       annotation: false,
      //   //     },
      //   //   },
      //   // }),
      // ] : [],
    },
  }
}

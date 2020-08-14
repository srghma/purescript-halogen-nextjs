import * as RA from 'ramda-adjunct'
import MiniCssExtractPlugin from 'mini-css-extract-plugin'

module.exports = function({ target, production }) {
  return [
    ...(require('webpack-spago-loader/rules')({ spagoAbsoluteOutputDir: require('../lib/spago-options').output })),

    // For pure CSS (without CSS modules)
    {
      test: /\.css$/i,
      exclude: /\.module\.css$/i,
      use: RA.compact([
        MiniCssExtractPlugin.loader, // TODO: disable extraction when server
        "css-loader"
      ]),
    },

    // For CSS modules
    {
      test: /\.module\.css$/i,
      use: RA.compact([
        MiniCssExtractPlugin.loader,
        {
          loader: 'css-loader',
          options: {
            modules: true,
            importLoaders: 1,
          },
        },
        {
          loader: 'postcss-loader',
          options: {
            ident: 'postcss',
            minimize: true,
            plugins: {
              'postcss-import': {},
              'postcss-preset-env': {},
              'cssnano': { preset: 'default' },
              ...(
                production ?
                  {
                    '@fullhuman/postcss-purgecss': {
                      content: ['./app/**/*.js'],
                      defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
                    }
                  } :
                  undefined
              )
            }
          },
        }
      ]),
    },
    // images
    {
      test: /\.(png|jpg|gif)$/i,
      use: [
        {
          loader: 'url-loader',
          options: {
            limit: 8192,
          },
        },
      ],
    },
  ]
}

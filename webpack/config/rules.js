import * as RA from 'ramda-adjunct'
import MiniCssExtractPlugin from 'mini-css-extract-plugin'

module.exports = function() {
  return [
    ...(require('webpack-spago-loader/rules')()),

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
            importLoaders: 2,
          },
        },
        'postcss-loader'
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

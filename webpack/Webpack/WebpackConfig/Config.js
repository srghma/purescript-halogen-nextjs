exports._MiniCssExtractPlugin = function(opts) {
  const MiniCssExtractPlugin = require("mini-css-extract-plugin")
  return new MiniCssExtractPlugin(opts)
}

const webpack = require("webpack")

exports.webpack = {
  _DefinePlugin: function(opts) {
    return new webpack.DefinePlugin(opts)
  },
  _ProvidePlugin: function(opts) {
    return new webpack.ProvidePlugin(opts)
  },
  _NoEmitOnErrorsPlugin: new webpack.NoEmitOnErrorsPlugin(),
  optimize: {
    _LimitChunkCountPlugin: function(opts) { return new webpack.optimize.LimitChunkCountPlugin(opts) }
  }
}

exports._CleanWebpackPlugin = new (require("clean-webpack-plugin").CleanWebpackPlugin)()

exports._BundleAnalyzerPlugin = function (opts) { return new (require("webpack-bundle-analyzer").BundleAnalyzerPlugin)(opts) }

exports._HtmlWebpackPlugin = function (opts) { new (require("html-webpack-plugin"))(opts) }

exports.htmlWebpackPlugin__tags__toString = function (tags) { return tags.toString() }

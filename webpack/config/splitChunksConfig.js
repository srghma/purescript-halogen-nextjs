// from https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L346

import * as crypto from 'crypto'

// this is default config from webpack site
module.exports = function({ totalPages }) {
  return {
    chunks: 'all',

    cacheGroups: {
      // only output is added
      defaultVendors: {
        test: /[\\/](node_modules|output)[\\/]/,
        priority: -10
      },

      // TODO: empty chunks https://github.com/webpack/webpack/issues/7300
      'default': {
        minChunks: 2,
        priority: -20,
        reuseExistingChunk: true
      },

      styles: {
        name: 'styles',
        test: /\.s?css$/,
        chunks: 'all',
        minChunks: 2,
        enforce: true,
        reuseExistingChunk: true,
      },

      commons: {
        name: 'commons',
        minChunks: totalPages,
        priority: 20,
      },
    },
  }
}

// from https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L346

import * as crypto from 'crypto'

module.exports.dev = {
  chunks: 'all',
  cacheGroups: {
    default: false,
    vendors: false,
  },
}

// this is default config from webpack site
module.exports.prod = function({ totalPages }) {
  return {
    chunks: 'all',
    // chunks: 'async',
    // minChunks: 1,
    // minSize: 30000,
    // name: true,

    cacheGroups: {
      // only output is added
      defaultVendors: {
        // test: module => {
        //   return /[\\/](node_modules|output)[\\/]/.test(module.resource)
        // },
        test: /[\\/](node_modules|output)[\\/]/,
        priority: -10
      },

      // TODO: empty chunks https://github.com/webpack/webpack/issues/7300
      'default': {
        minChunks: 2,
        priority: -20,
        reuseExistingChunk: true
      },

      // framework: {
      //   chunks: 'all',
      //   name: 'framework',
      //   // This regex ignores nested copies of framework libraries so they're
      //   // bundled with their issuer.
      //   // https://github.com/vercel/next.js/pull/9012

      //   // TODO: except halogen MDL
      //   test: /[\\/]output[\\/]Halogen/,
      //   priority: 40,
      //   // Don't let webpack eliminate this chunk (prevents this chunk from
      //   // becoming a part of the commons chunk)
      //   enforce: true,
      // },
      // lib: {
      //   test(module) {
      //     return (
      //       module.size() > 160000 &&
      //       /node_modules[/\\]/.test(module.identifier())
      //     )
      //   },
      //   name(module) {
      //     const hash = crypto.createHash('sha1')
      //     if (isModuleCSS(module)) {
      //       module.updateHash(hash)
      //     } else {
      //       if (!module.libIdent) {
      //         throw new Error(
      //           `Encountered unknown module type: ${module.type}. Please open an issue.`
      //         )
      //       }

      //       hash.update(module.libIdent({ context: dir }))
      //     }

      //     return hash.digest('hex').substring(0, 8)
      //   },
      //   priority: 30,
      //   minChunks: 1,
      //   reuseExistingChunk: true,
      // },
      // commons: {
      //   name: 'commons',
      //   minChunks: totalPages,
      //   priority: 20,
      // },
      // shared: {
      //   name(module, chunks) {
      //     return (
      //       crypto
      //         .createHash('sha1')
      //         .update(
      //           chunks.reduce(
      //             (acc, chunk) => {
      //               return acc + chunk.name
      //             },
      //             ''
      //           )
      //         )
      //         .digest('hex') + (isModuleCSS(module) ? '_CSS' : '')
      //     )
      //   },
      //   priority: 10,
      //   minChunks: 2,
      //   reuseExistingChunk: true,
      // },
    },
  }
}

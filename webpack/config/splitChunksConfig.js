// from https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L346

import * as crypto from 'crypto'
import * as RA from 'ramda-adjunct'
import root from '../lib/root'

const isModuleCSS = (module) => {
  return (
    // mini-css-extract-plugin
    module.type === `css/mini-extract` ||
    // extract-css-chunks-webpack-plugin (old)
    module.type === `css/extract-chunks` ||
    // extract-css-chunks-webpack-plugin (new)
    module.type === `css/extract-css-chunks`
  )
}

// this is default config from webpack site
module.exports = function({ totalPages }) {
  if (!(RA.isInteger(totalPages) && RA.isPositive(totalPages))) { throw new Error(`totalPages is invalid, got ${totalPages}`) }

  return {
    chunks: 'all',
    cacheGroups: {
      default: false,
      vendors: false,
      framework: {
        chunks: 'all',
        name: 'framework',
        // This regex ignores nested copies of framework libraries so they're
        // bundled with their issuer.
        // https://github.com/vercel/next.js/pull/9012
        test: /(?<!node_modules.*)[\\/]node_modules[\\/](react|react-dom|scheduler|prop-types|use-subscription)[\\/]/,
        priority: 40,
        // Don't let webpack eliminate this chunk (prevents this chunk from
        // becoming a part of the commons chunk)
        enforce: true,
      },
      lib: {
        test(module) {
          return (
            module.size() > 160000 &&
            /node_modules[/\\]/.test(module.identifier())
          )
        },
        name(module) {
          const hash = crypto.createHash('sha1')
          if (isModuleCSS(module)) {
            module.updateHash(hash)
          } else {
            if (!module.libIdent) {
              throw new Error(
                `Encountered unknown module type: ${module.type}. Please open an issue.`
              )
            }

            hash.update(module.libIdent({ context: root }))
          }

          return hash.digest('hex').substring(0, 8)
        },
        priority: 30,
        minChunks: 1,
        reuseExistingChunk: true,
      },
      commons: {
        name: 'commons',
        minChunks: totalPages,
        priority: 20,
      },
      shared: {
        name(module, chunks) {
          return (
            crypto
              .createHash('sha1')
              .update(
                chunks.reduce(
                  (acc, chunk) => {
                    return acc + chunk.name
                  },
                  ''
                )
              )
              .digest('hex') + (isModuleCSS(module) ? '_CSS' : '')
          )
        },
        priority: 10,
        minChunks: 2,
        reuseExistingChunk: true,
      },
    },
    maxInitialRequests: 25,
    minSize: 20000,
  }
}

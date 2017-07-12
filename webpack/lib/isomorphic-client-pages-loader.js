// FROM https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/webpack/loaders/next-client-pages-loader.ts

import { loader } from 'webpack'
import loaderUtils from 'loader-utils'

// export type ClientPagesLoaderOptions = {
//   absoluteCompiledPagePursPath: string // e.g. ".../output/Foo/index.js"
//   absoluteJsDepsPath: string | null // e.g. ".../app/Pages/Foo.deps.js" or null
//   pageName: string // e.g. "Foo"
// }

// check createClientPagesEntrypoints for more

const clientPagesLoader = async function() {
  const this_ = this

  this_.cacheable && this_.cacheable()

  const callback = this_.async();

  const {
    absoluteCompiledPagePursPath,
    absoluteJsDepsPath,
    pageName,
  } = loaderUtils.getOptions(this_)

  if (!absoluteCompiledPagePursPath) { throw new Error('absoluteCompiledPagePursPath is empty') }
  if (!pageName) { throw new Error('pageName is empty') }

  const loadJsDepsTemplate = absoluteJsDepsPath ? `require(${JSON.stringify(absoluteJsDepsPath)});` : ""
  const loadPageTemplate = `(window.__PAGE_CACHE_BUS=window.__PAGE_CACHE_BUS||[]).push({ pageName: ${JSON.stringify(pageName)}, page: require(${JSON.stringify(absoluteCompiledPagePursPath)}).page });`

  const output = loadJsDepsTemplate + loadPageTemplate

  callback(null, output)
}

export default clientPagesLoader

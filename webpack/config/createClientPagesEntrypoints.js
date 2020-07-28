// Copy of
//
// https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/entries.ts#L131
// https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L665-L676
//
// More how everything should work:
//
// https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/webpack/loaders/next-client-pages-loader.ts
// https://github.com/vercel/next.js/blob/7dbdf1d89eef004170d8f2661b4b3c299962b1f8/packages/next/client/index.js#L58
// https://github.com/vercel/next.js/blob/42a328f3e44a560d45821a582beb257fdeea10af/packages/next/client/link.tsx#L204
// script prefetched https://github.com/vercel/next.js/blob/3036463080d7905aa22da46e63f6c50dd50adc3c/packages/next/client/page-loader.js#L36-L49
// script added https://github.com/vercel/next.js/blob/42a328f3e44a560d45821a582beb257fdeea10af/packages/next/client/page-loader.js#L254

import root from '../lib/root'
import * as path from 'path'
import * as fs from 'fs'
import * as fse from 'fs-extra'
import * as R from 'ramda'
import * as RA from 'ramda-adjunct'
import firstline from 'firstline'

async function getFileModule(filePath) {
  const firstLine = await firstline(filePath)

  let moduleName

  try {
    moduleName = R.match(/module (\S+)/, firstLine)[1].trim()
  } catch (e) {
    moduleName = null
  }

  if (!moduleName) {
    throw new Error(`cannot find module name in first line ${firstLine}`)
  }

  return moduleName
}

const entryPair =
  pagesDir =>
  async (fileName) => // e.g. Foo.purs
  {
    const filePath = path.join(pagesDir, fileName)
    const moduleName = await getFileModule(filePath) // moduleName = e.g. Nextjs.Pages.Foo
    const absoluteCompiledPagePursPath = path.resolve(root, "output", moduleName, "index.js") // e.g. ".../output/Foo/index.js"
    const pageName = path.parse(fileName).name // e.g. Foo

    const absoluteJsDepsPath = path.join(pagesDir, `${pageName}.deps.js`)
    const absoluteJsDepsPath_ = fs.existsSync(absoluteJsDepsPath) ? absoluteJsDepsPath : null

    const pageLoader = {
      pageName,
      absoluteCompiledPagePursPath,
      absoluteJsDepsPath: absoluteJsDepsPath_,
    }

    return [pageName, pageLoader]
  }

export default async function(pagesDir) {
  const allTopFiles = await fse.readdir(pagesDir) // e.g. ["Foo.deps.js", "Foo.purs"]

  const pageFiles = R.filter(R.test(/\.purs$/), allTopFiles)

  const entryPairs_ = await Promise.all(R.map(entryPair(pagesDir), pageFiles))

  const entryPairsObject = R.fromPairs(entryPairs_)

  return entryPairsObject
}

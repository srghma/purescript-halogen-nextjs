import * as RA from 'ramda-adjunct'

// tags: {
//   headTags: HtmlTagArray(1) [
//     {
//       tagName: 'link',
//       voidTag: true,
//       attributes: { href: './index.css', rel: 'stylesheet' },
//       toString: [Function (anonymous)]
//     }
//   ],
//   bodyTags: HtmlTagArray(1) [
//     {
//       tagName: 'script',
//       voidTag: false,
//       attributes: { defer: false, src: './index.js' },
//       toString: [Function (anonymous)]
//     }
//   ]
// },
// files: {
//   publicPath: './',
//   js: [ './index.js' ],
//   css: [ './index.css' ],
//   manifest: undefined,
//   favicon: undefined
// },
// options: {
//   template: '/home/srghma/projects/purescript-halogen-nextjs/node_modules/html-webpack-plugin/lib/loader.js!/home/srghma/projects/purescript-halogen-nextjs/node_modules/html-webpack-plugin/default_index.ejs',
//   templateContent: [Function (anonymous)],
//   templateParameters: [Function: templateParametersGenerator],
//   filename: 'index.html',
//   hash: false,
//   inject: 'body',
//   scriptLoading: 'blocking',
//   compile: true,
//   favicon: false,
//   minify: false,
//   cache: true,
//   showErrors: true,
//   chunks: 'all',
//   excludeChunks: [],
//   chunksSortMode: 'auto',
//   meta: {},
//   base: false,
//   title: 'Purescript Nextjs',
//   xhtml: false
// }

// <!DOCTYPE html>
// <html>
//     <head>
//         <title>Index</title>
//         <link rel="preload" as="script" href="/webpack.js"/>
//         <link rel="preload" as="script" href="/chunks/main.js"/>
//         <link rel="preload" as="script" href="/chunks/Index.js"/>
//         <link rel="stylesheet" href="/css/main.css"/>
//     </head>
//     <body>
//         <div id="root">
//         </div>
//
//         <script async="" type="application/javascript" src="/webpack.js"></script>
//         <script async="" type="application/javascript" src="/chunks/main.js"></script>
//         <script async="" type="application/javascript" src="/chunks/Index.js"></script>
//     </body>
// </html>


// Customize this policy to fit your own app's needs. For more guidance, see:
//     https://github.com/apache/cordova-plugin-whitelist/blob/master/README.md#content-security-policy
// Some notes:
//     * gap: is required only on iOS (when using UIWebView) and is needed for JS->native communication
//     * https://ssl.gstatic.com is required only on Android and is needed for TalkBack to function properly
//     * Disables use of inline scripts in order to mitigate risk of XSS vulnerabilities. To change this:
//         * Enable inline JS: add 'unsafe-inline' to default-src
var cordovaSecurityPolicy = `<meta http-equiv="Content-Security-Policy" content="` +
  [
    `default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'`,
    `style-src 'self' 'unsafe-inline'`,
    `media-src *`,
    `img-src 'self' data: content:`,
    `connect-src *`, // connect-src * allows to fetch() any url
  ].join('; ') + `">`

export function template({
  target,
  title,
  prerenderedHtml,
  prerenderedPagesManifest,
  prerenderedPageData,
  headTags,
  bodyTags,
}) {
  if (target !== 'mobile' && target !== 'server') { throw new Error(`target is invalid, got ${target}`) }
  if (!RA.isNonEmptyString(title)) { throw new Error(`title is invalid, got ${title}`) }
  if (target === 'server'&& !RA.isNonEmptyString(prerenderedHtml)) { throw new Error(`prerenderedHtml is invalid, got ${prerenderedHtml}`) }
  if (target === 'server'&& !RA.isNonEmptyString(prerenderedPagesManifest)) { throw new Error(`prerenderedPagesManifest is invalid, got ${prerenderedPagesManifest}`) }
  if (target === 'server'&& !(RA.isNull(prerenderedPageData) || RA.isNonEmptyString(prerenderedPageData))) { throw new Error(`prerenderedPageData is invalid, got ${prerenderedPageData}`) }
  if (!RA.isNonEmptyString(headTags)) { throw new Error(`headTags is invalid, got ${headTags}`) }
  if (!RA.isNonEmptyString(bodyTags)) { throw new Error(`bodyTags is invalid, got ${bodyTags}`) }

  // console.log('options', require('util').inspect(options.htmlWebpackPlugin, { depth: null, maxArrayLength: Infinity, colors: true }))

  const meta =
    target === 'mobile' ?
    cordovaSecurityPolicy + `
      <meta name="format-detection" content="telephone=no">
      <meta name="msapplication-tap-highlight" content="no">
      <meta name="viewport" content="initial-scale=1,width=device-width,viewport-fit=cover">` :
    target === 'server' ? `
      <meta name="viewport" content="initial-scale=1,width=device-width"/>` :
    ''

  return `
  <!DOCTYPE html>
  <html>
    <head>
      ${meta}
      <meta charset="utf-8"/>
      <title>${title}</title>
      <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet" />
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      ${headTags}
    </head>
    <body class="mdc-typography mdc-theme--background">
      <div id="root">${target === 'server' ? prerenderedHtml : ''}</div>
      ${target === 'server' ? `<script id="__PAGES_MANIFEST__" type="application/json">${prerenderedPagesManifest}</script>` : ''}
      ${target === 'server' && prerenderedPageData ? `<script id="__PAGE_DATA__" type="application/json">${prerenderedPageData}</script>` : ''}
      ${target === 'mobile' ? `<script type="text/javascript" src="cordova.js"></script>` : ''}
      ${bodyTags}
    </body>
  </html>
  `
}

import * as RA from 'ramda-adjunct'

// Customize this policy to fit your own app's needs. For more guidance, see:
//     https://github.com/apache/cordova-plugin-whitelist/blob/master/README.md#content-security-policy
// Some notes:
//     * gap: is required only on iOS (when using UIWebView) and is needed for JS->native communication
//     * https://ssl.gstatic.com is required only on Android and is needed for TalkBack to function properly
//     * Disables use of inline scripts in order to mitigate risk of XSS vulnerabilities. To change this:
//         * Enable inline JS: add 'unsafe-inline' to default-src
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

  const cordovaSecurityPolicy = `<meta http-equiv="Content-Security-Policy" content="` +
    [
      `default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'`,
      `style-src 'self' 'unsafe-inline'`,
      `media-src *`,
      `img-src 'self' data: content:`,
      `connect-src *`, // connect-src * allows to fetch() any url
    ].join('; ') + `">`

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
      <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
      <link href="https://fonts.googleapis.com/css?family=Material+Icons&display=block" rel="stylesheet">
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

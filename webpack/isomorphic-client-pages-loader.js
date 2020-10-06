// XXX: hack, because it's not possible to write loader as a function https://github.com/webpack/webpack/issues/119
//
// https://github.com/webpack/webpack/issues/11581

const path = require('path')

const loaderPath = path.join(__dirname, '..', 'output', 'NextjsWebpack.IsomorphicClientPagesLoader', 'index.js')

module.exports = require(loaderPath).loader

if (!(module.exports instanceof Function)) { throw new Error('NextjsWebpack.IsomorphicClientPagesLoader is not a function') }

// XXX: hack, because it's not possible to write loader as a function https://github.com/webpack/webpack/issues/119

module.exports = require('./output/NextjsWebpack.IsomorphicClientPagesLoader/index.js').loader

if (!(module.exports instanceof Function)) { throw new Error('NextjsWebpack.IsomorphicClientPagesLoader is not a function') }

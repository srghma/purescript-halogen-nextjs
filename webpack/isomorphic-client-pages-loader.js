// XXX: hack, because it's not possible to write loader as a function https://github.com/webpack/webpack/issues/119

module.exports = require('./output/Webpack.IsomorphicClientPagesLoader/index.js').loader

if (!(module.exports instanceof Function)) { throw new Error('Webpack.IsomorphicClientPagesLoader is not a function') }

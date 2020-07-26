require("@babel/register")({
  presets: ['@babel/preset-env'],
  plugins: ['@babel/plugin-transform-runtime']
})

const createConfig = require('./config').default

module.exports = createConfig({ production: true, browser: true })

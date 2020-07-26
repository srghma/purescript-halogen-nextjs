require("@babel/register")({
  presets: ['@babel/preset-env'],
  plugins: ['@babel/plugin-transform-runtime']
})

const createConfig = require('./config').default

module.exports = function(env) {
  if(!env) { throw new Error('env should be specified explicitly, but got ' + env) }

  const production = env.mode === 'production'

  const config = createConfig({ production, target: 'mobile' })

  console.log(config)

  return config
}

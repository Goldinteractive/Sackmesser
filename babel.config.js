module.exports = function(api) {
  api.cache.forever()

  const presets = ['@babel/preset-env']
  const plugins = [
    ['@babel/plugin-proposal-decorators', { decoratorsBeforeExport: true }],
    '@babel/plugin-proposal-class-properties',
    '@babel/plugin-transform-classes'
  ]

  return {
    presets,
    plugins
  }
}

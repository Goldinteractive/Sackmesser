module.exports = function(api) {
  api.cache.forever()

  const presets = ['@babel/preset-env']
  const plugins = [
    ['@babel/plugin-proposal-decorators', { decoratorsBeforeExport: true }],
    '@babel/plugin-proposal-class-properties',
    '@babel/plugin-transform-classes',
    '@babel/plugin-proposal-optional-chaining',
    '@babel/plugin-proposal-nullish-coalescing-operator',
    'babel-plugin-dev-expression'
  ]

  return {
    presets,
    plugins
  }
}

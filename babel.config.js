module.exports = function (api) {
  api.cache.forever()

  const presets = [
    '@babel/preset-env',
    '@babel/preset-react'
  ]
  const plugins = [
    ["@babel/plugin-proposal-decorators", { "legacy": true }],
    '@babel/plugin-transform-runtime',
    ["@babel/plugin-proposal-class-properties", { "loose": true }],
    '@babel/plugin-transform-classes',
    '@babel/plugin-proposal-optional-chaining',
    '@babel/plugin-proposal-nullish-coalescing-operator',
    'babel-plugin-dev-expression',
  ]

  return {
    presets,
    plugins,
  }
}

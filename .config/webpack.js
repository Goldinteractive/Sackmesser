const webpack = require('webpack'),
  BowerWebpackPlugin = require('bower-webpack-plugin'),
  path = require('path'),
  IS_DEBUG = process.env.DEBUG && process.env.DEBUG != 'false',
  IS_WATCH = process.env.WATCH && process.env.WATCH != 'false',
  BASE = path.join(__dirname, '..', process.env.BASE)

// default plugins
var plugins = [
  new webpack.ProvidePlugin({
    gi: 'base',
    $: 'jquery',
    jQuery: 'jquery',
  })
]

// Extend the default plugins to
// minify everything in production
// adding the credits as well
if (!IS_DEBUG)
  plugins = plugins.concat([
    new webpack.optimize.UglifyJsPlugin({
      comments: false,
      compress: {
        warnings: false
      }
    }),
    new webpack.BannerPlugin(`Gold Interactive - www.goldinteractive.ch - ${ new Date().getFullYear() }`)
  ])

module.exports = {
  resolve: {
    modulesDirectories: [
        BASE, 'node_modules'
    ]
  },
  entry: path.join(BASE, process.env.IN),
  target: 'web',
  cache: true,
  bail: !IS_WATCH, // exit the build process in case of errors
  output: {
    path: BASE,
    filename: process.env.OUT,
    sourceMapFilename: `${process.env.OUT}.map`
  },
  devtool: IS_DEBUG ? '#source-map' : false,
  watch: IS_WATCH,
  module: {
    loaders: [
      // { test: require.resolve('jquery'), loader: 'expose?$!expose?jQuery' },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower)/,
        loader: 'babel',
        query: {
          cacheDirectory: true,
          presets: ['es2015']
        }
      },
      {
        test: /\.json$/,
        exclude: /node_modules|bower/,
        loader: 'json-loader'
      }
    ]
  },
  plugins: plugins
}


const webpack = require('webpack'),
  path = require('path'),
  IS_DEBUG = process.env.DEBUG && process.env.DEBUG != 'false',
  IS_WATCH = process.env.WATCH && process.env.WATCH != 'false',
  BASE = path.join(__dirname, '..', process.env.BASE)

module.exports = {
  entry: path.join(BASE, process.env.IN),
  target: 'web',
  cache: true,
  output: {
    path: BASE,
    filename: process.env.OUT,
    sourceMapFilename: `${process.env.OUT}.map`
  },
  devtool: IS_DEBUG ? '#source-map' : false,
  watch: IS_WATCH,
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules|bower/,
        loader: 'babel-loader?presets[]=es2015'
      },
      {
        test: /\.html$/,
        exclude: /node_modules|bower/,
        loader: 'html-loader?attrs=none'
      },
      {
        test: /\.json$/,
        exclude: /node_modules|bower/,
        loader: 'json-loader'
      }
    ]
  },
  resolve: {
    alias: {
    }
  },
  plugins: [
    new webpack.ProvidePlugin({
      // $: 'jquery'
    }),
    // minify by default
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: IS_DEBUG
    })
  ]
}


const webpack = require('webpack'),
  path = require('path')

// default plugins
var plugins = [
  new webpack.ProvidePlugin({
    gi: '@goldinteractive/js-base/src',
    base: '@goldinteractive/js-base/src',
    $: 'jquery',
    jQuery: 'jquery'
  }),
  new webpack.LoaderOptionsPlugin({
    options: {
      context: __dirname
    }
  })
]


module.exports = function(env) {

    const IS_DEBUG = process.env.DEBUG && process.env.DEBUG != 'false',
      IS_WATCH = process.env.WATCH && process.env.WATCH != 'false',
      BASE = path.join(__dirname, '..', process.env.BASE)

    // Extend the default plugins to
    // minify everything in production
    // adding the credits as well
    if (!IS_DEBUG) {
      plugins = plugins.concat([
        new webpack.optimize.UglifyJsPlugin({
          sourceMap: IS_DEBUG ? true : false,
          comments: false,
          compress: {
            warnings: false
          }
        }),
        new webpack.LoaderOptionsPlugin({
          minimize: true
        }),
        new webpack.BannerPlugin({
          banner: `Gold Interactive - www.goldinteractive.ch - ${ new Date().getFullYear() }`
        })
      ])
    }


    var config = {
      resolve: {
        modules: [
            BASE, 'node_modules'
        ]
      },
      plugins: plugins,
      entry: path.join(BASE, process.env.IN),
      target: 'web',
      cache: true,
      bail: !IS_WATCH, // exit the build process in case of errors
      output: {
        path: BASE,
        filename: `${process.env.OUT}`,
        sourceMapFilename: `${process.env.OUT}.map`
      },
      devtool: IS_DEBUG ? '#source-map' : false,
      watch: IS_WATCH,
      module: {
        rules: [
          {
            test: /\.js$/,
            exclude: /(node_modules|bower)/,
            loader: 'babel-loader',
            query: {
              presets: [
                ['es2015', { modules: false }]
              ]
            }
          },
          {
            test: /@goldinteractive\/(?!.+node_modules)/,
            loader: 'babel-loader',
            query: {
              presets: [
                ['es2015', { modules: false }]
              ]
            }
          }
        ]
      }
    }

    return config

}


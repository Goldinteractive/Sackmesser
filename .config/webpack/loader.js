const path = require('path');
const paths = require('../paths');
const jsonImporter = require('node-sass-json-importer')

const sassLoader = {
  loader: 'sass-loader',
  options: {
    includePaths: [paths.app.cssBase, 'node_modules'],
    importer: jsonImporter
  }
}

const postcssLoader = {
  loader: 'postcss-loader',
  options: {
    config: {
      path: path.resolve('.config/postcss.config.js')
    }
  }
}

// Note that svg fonts won't be picked up by this loader
const fontLoader = () => ({
  test: /\.(ttf|eot|woff|woff2)$/,
  use: {
    loader: 'file-loader',
    options: {
      name: 'fonts/[name].[ext]'
    }
  }
})


const imageLoader = ({ isProd, assetHash }) => ({
  test: /\.(gif|png|jpe?g|svg)$/i,
  use: [
    {
      loader: 'file-loader',
      options: {
        name: isProd ? '[hash].[ext]' : '[path][name].[ext]',
        outputPath: '/files/',
        publicPath: assetHash + '/files/',
        context: 'frontend'
      }
    },
    {
      loader: 'image-webpack-loader',
      options: {
        disable: true, // disabled in dev mode
        optipng: {
          enabled: false
        },
        pngquant: {
          quality: '90-95'
        }
      }
    }
  ]
})

module.exports = {
  sassLoader: sassLoader,
  postcssLoader: postcssLoader,
  fontLoader: fontLoader,
  imageLoader: imageLoader,
}

var importCss = require('postcss-import')
var autoprefixer = require('autoprefixer')
var objectFit = require('postcss-object-fit-images')
var pxToRem = require('postcss-pxtorem')
var assets = require('postcss-assets')
var mqpacker = require('css-mqpacker')
var cssnano = require('cssnano')

module.exports = (ctx) => {
  return {
    map: false,
    plugins: [
      importCss(),
      autoprefixer(),
      objectFit(),
      pxToRem({
        rootValue: 16,
        unitPrecision: 5,
        propWhiteList: ['font', 'font-size', 'line-height', 'letter-spacing'],
        replace: true,
        mediaQuery: false,
        minPixelValue: 2
      }),
      mqpacker(),
      assets({
        basePath: process.env.ASSETS_PATH,
        loadPaths: ['img', 'fonts'],
        relative: true,
        cachebuster: true
      }),
      cssnano({
        zindex: false
      })
    ]
  }
}


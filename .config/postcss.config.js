module.exports = {
  plugins: [
    require('autoprefixer'),
    require('postcss-import'),
    require('postcss-pxtorem')({
      rootValue: 16,
      unitPrecision: 5,
      propWhiteList: ['font', 'font-size', 'line-height', 'letter-spacing'],
      replace: true,
      mediaQuery: false,
      minPixelValue: 2
    }),
    require('cssnano')({
      zindex: false,
      reduceIdents: false
    })
  ]
}

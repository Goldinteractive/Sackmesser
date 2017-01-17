module.exports = {
    'use': ['postcss-import', 'postcss-pxtorem', 'postcss-assets', 'css-mqpacker', 'cssnano'],
    'cssnano': {
        zindex: false,
        browsers: '> 5%'
    },
    'postcss-pxtorem': {
        rootValue: 16,
        unitPrecision: 5,
        propWhiteList: ['font', 'font-size', 'line-height', 'letter-spacing'],
        replace: true,
        mediaQuery: false,
        minPixelValue: 2
    },
    'postcss-assets': {
        basePath: process.env.ASSETS_PATH,
        loadPaths: ['img', 'fonts'],
        relative: true,
        cachebuster: true
    }
}

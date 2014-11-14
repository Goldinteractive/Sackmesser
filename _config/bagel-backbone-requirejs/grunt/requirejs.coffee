module.exports = build:
  options:
    baseUrl: 'public/assets/js'
    out: 'dist/public/assets/js/build.min.js'
    mainConfigFile: 'public/assets/js/require-config.js'
    name: '../vendor/bower/almond/almond'
    include: ['main']
    insertRequire: ['main']
    wrap: true
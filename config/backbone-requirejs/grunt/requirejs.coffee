module.exports = build:
  options:
    baseUrl: "assets/js"
    out: "dist/assets/js/build.min.js"
    mainConfigFile: "assets/js/require-config.js"
    name: "../vendor/almond/almond"
    include: ["main"]
    insertRequire: ["main"]
    wrap: true
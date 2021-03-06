module.exports = () => ({
  // configure css entry points, convention: 'style' will be resolved to 'css/style.scss'
  cssEntries: [],
  // configure js entry points, convention: 'main' will be resolved to 'js/main'
  // note that for js file endings will be assumed by webpack
  jsEntries: ['main', 'feature-detector'],
  // Which node_modules shall be transpiled by babel?
  compileBundleEntries: [
    /@goldinteractive\/js-base/,
    /@goldinteractive\/feature-/
  ]
})

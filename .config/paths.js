const fs = require('fs');
const path = require('path');

const appDirectory = fs.realpathSync(process.cwd());
const resolveApp = relativePath => path.resolve(appDirectory, relativePath);

module.exports = {
  app: {
    root: appDirectory,
    frontend: resolveApp('frontend'),
    cssBase: resolveApp('frontend/css'),
    jsBase: resolveApp('frontend/js'),
    publicPath: resolveApp('frontend/_public'),
    nodeModules: resolveApp('node_modules'),
    templates: resolveApp('ui/templates'),
  },
}

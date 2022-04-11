const loaders = require('./webpack/loader')
const webpack = require('webpack')
const paths = require('./paths')
const path = require('path')
const assert = require('assert')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const IgnoreAssetsWebpackPlugin = require('@goldinteractive/ignore-assets-webpack-plugin')
const dotenv = require('dotenv')
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin

const appConfiguration = require('./app-configuration')

const ASSET_HASH_REGEX = '@ASSET_HASH'
// which file types should be checked for asset hash regex?
const ASSET_HASH_REPLACEMENT_FILE_TYPES_WHITELIST = [
  '.html',
  '.twig',
  '.php',
  '.js',
  '.jsx',
  '.css'
]

const buildBaseConfig = ({ isProd }) => ({
  watch: !isProd,
  bail: isProd,
  target: 'web',
  performance: {
    maxEntrypointSize: 700000,
    maxAssetSize: 700000
  },
  stats: isProd ? 'minimal' : 'normal',
  devtool: isProd ? false : 'source-map',
})

const pushIfSet = (bool, entry, array = []) => {
  if (bool) {
    return array.concat([entry])
  }
  return array
}

const buildBasePlugins = ({ isProd }) =>
  pushIfSet(
    isProd,
    new webpack.BannerPlugin({
      banner: `Gold Interactive GmbH - www.goldinteractive.ch - ${new Date().getFullYear()}`
    })
  )

const buildCssConfig = (cssEntry, { assetHash, isProd, assetDir }) => ({
  ...buildBaseConfig({
    isProd
  }),
  entry: {
    [cssEntry]: path.join(paths.app.cssBase, cssEntry + '.scss')
  },
  resolve: {
    modules: [paths.app.cssBase, paths.app.frontend, 'node_modules']
  },
  output: {
    path: assetDir,
    publicPath: '',
  },
  module: {
    rules: [
      {
        test: /\.s?css$/,
        use: [
          'file-loader?name=[name].css',
          'extract-loader',
          'css-loader',
          loaders.postcssLoader,
          loaders.sassLoader
        ]
      },
      loaders.fontLoader(),
      loaders.imageLoader({ isProd, assetHash })
    ]
  },
  plugins: [
    ...buildBasePlugins({
      isProd
    }),
    new IgnoreAssetsWebpackPlugin({
      ignore: cssEntry + '.js'
    })
  ]
})

const buildJsConfig = (
  jsEntries,
  { assetHash, isProd, assetDir, compileBundleEntries, enableBundleAnalyzer }
) => {
  let entryPoints = {}
  jsEntries.forEach(jsEntry => {
    entryPoints[jsEntry] = path.join(paths.app.jsBase, jsEntry)
  })

  return {
    ...buildBaseConfig({
      isProd,
    }),
    entry: entryPoints,
    resolve: {
      extensions: ['.js', '.json', '.jsx'],
      modules: [paths.app.jsBase, paths.app.frontend, 'node_modules'],
    },
    output: {
      filename: '[name].js',
      publicPath: 'assets/',
      path: assetDir,
    },
    module: {
      rules: [
        {
          test: /\.jsx?$/,
          exclude: /node_modules/,
          loader: 'babel-loader',
          options: {
            cacheDirectory: true,
          },
        },
        {
          test: /\.jsx?$/,
          loader: 'babel-loader',
          include: compileBundleEntries,
          options: {
            cacheDirectory: true,
          },
        },
        {
          test: /\.worker\.js$/,
          use: {
            loader: 'worker-loader',
            options: {
              name: '[hash]-[name].js',
              publicPath: `${assetHash}/`,
            },
          },
        },
        {
          test: /\.s?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            loaders.postcssLoader,
            loaders.sassLoader
          ],
        },
        loaders.fontLoader(),
        loaders.imageLoader({ isProd, assetHash })
      ],
    },
    plugins: [
      ...buildBasePlugins({
        isProd,
      }),
      new MiniCssExtractPlugin({
        filename: '[name].css',
      }),
      new webpack.DefinePlugin({
        __ASSET_HASH__: '"' + assetHash + '"',
      }),
      new BundleAnalyzerPlugin({
        analyzerMode: enableBundleAnalyzer ? 'static' : 'disabled'
      }),
    ],
    optimization: {
      splitChunks: {
        cacheGroups: {
          commons: {
            name: 'commons',
            chunks: 'initial',
            minChunks: 2,
          },
        },
      },
    },
  }
}

const buildProjectSkeletonConfig = ({
                                      jsEntries,
                                      assetHash,
                                      isProd,
                                      assetDir,
                                      assetHashTemplateReplacePath
                                    }) => ({
  ...buildBaseConfig({
    isProd
  }),
  entry: {
    // Webpack needs an entry...
    [jsEntries[0]]: path.join(paths.app.jsBase, jsEntries[0])
  },
  output: {
    filename: '[name].js',
    path: assetDir
  },
  module: {
    rules: [
      {
        // match all
        test: /[\s\S]*/,
        use: 'null-loader'
      }
    ]
  },
  plugins: [
    new IgnoreAssetsWebpackPlugin({
      ignore: jsEntries[0] + '-omit.js'
    }),
    ...buildBasePlugins({
      isProd
    }),
    new CopyWebpackPlugin([
      {
        from: paths.app.publicPath,
        to: '..',
        transform: (content, pathname) => {
          if (
            assetHashTemplateReplacePath &&
            typeof assetHashTemplateReplacePath === 'string'
          ) {
            const fullPath = path.join(paths.app.root, assetHashTemplateReplacePath)
            // One must not stringify binary files such as png, glb, etc.
            const isInFileTypeWhiteList =
              ASSET_HASH_REPLACEMENT_FILE_TYPES_WHITELIST.find(fileType =>
                pathname.endsWith(fileType)
              ) !== undefined
            if (isInFileTypeWhiteList && pathname.startsWith(fullPath)) {
              const regex = new RegExp(ASSET_HASH_REGEX, 'g')
              return content.toString().replace(regex, assetHash)
            }
          }
          return content
        }
      }
    ]),
  ]
})

const validateEnvironmentVariables = env => {
  assert.ok(env.assetHash, 'assetHash must be set to non empty value.')
  assert.ok(env.publicDest, 'publicDest must be set to non empty value.')
}

module.exports = env => {
  validateEnvironmentVariables(env)
  const isProd = env.mode === 'production'
  const assetHash = env.assetHash
  const environment = env.environment
  const publicDest = env.publicDest
  const assetHashTemplateReplacePath = env.assetHashTemplateReplacePath
  const enableBundleAnalyzer = env.mode === 'development'

  // parses current .env file and provides all variables in process.env.XYZ
  // usage: process.env.APP_URL
  dotenv.config({
    path: path.join(paths.app.frontend, '.env.' + environment)
  })

  const baseOutputDir = path.join(paths.app.root, publicDest)
  const assetDir = baseOutputDir + '/' + assetHash
  const { jsEntries, cssEntries, compileBundleEntries } = appConfiguration(env)

  const configObject = {
    assetDir,
    assetHash,
    assetHashTemplateReplacePath,
    isProd,
    jsEntries,
    compileBundleEntries,
    enableBundleAnalyzer
  }

  return [
    buildProjectSkeletonConfig(configObject),
    buildJsConfig(jsEntries, configObject),
    ...cssEntries.map(cssEntry => buildCssConfig(cssEntry, configObject))
  ]
}

const webpack = require('webpack')
const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const IgnoreAssetsWebpackPlugin = require('@goldinteractive/ignore-assets-webpack-plugin')
const jsonImporter = require('node-sass-json-importer')
const dotenv = require('dotenv')

const appConfiguration = require('./app-configuration')

const frontendFolder = 'frontend'

const root = path.join(__dirname, '..')
const base = path.join(root, frontendFolder)
const jsBase = path.join(base, 'js')
const cssBase = path.join(base, 'css')
const publicPath = path.join(base, '_public')

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

const sassLoader = {
  loader: 'sass-loader',
  options: {
    includePaths: [cssBase, 'node_modules'],
    importer: jsonImporter
  }
}

const postcssLoader = {
  loader: 'postcss-loader',
  options: {
    config: {
      path: '.config/postcss.config.js'
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

const buildBaseConfig = ({ isProd }) => ({
  watch: !isProd,
  bail: isProd,
  target: 'web',
  performance: {
    maxEntrypointSize: 700000,
    maxAssetSize: 700000
  },
  stats: isProd ? 'minimal' : 'normal'
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
    [cssEntry]: path.join(cssBase, cssEntry + '.scss')
  },
  resolve: {
    modules: [cssBase, base, 'node_modules']
  },
  output: {
    filename: '[name].js',
    path: assetDir
  },
  module: {
    rules: [
      {
        test: /\.s?css$/,
        use: [
          'file-loader?name=[name].css',
          'extract-loader',
          'css-loader',
          postcssLoader,
          sassLoader
        ]
      },
      fontLoader(),
      imageLoader({ isProd, assetHash })
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

const buildJsConfig = (jsEntry, { assetHash, isProd, assetDir }) => ({
  ...buildBaseConfig({
    isProd
  }),
  entry: {
    [jsEntry]: path.join(jsBase, jsEntry + '.js')
  },
  resolve: {
    extensions: ['.js', '.json', '.jsx'],
    modules: [jsBase, base, 'node_modules']
  },
  output: {
    filename: '[name].js',
    path: assetDir
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        options: {
          cacheDirectory: true
        }
      },
      {
        test: /\.s?css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          postcssLoader,
          sassLoader
        ]
      },
      fontLoader(),
      imageLoader({ isProd, assetHash })
    ]
  },
  plugins: [
    ...buildBasePlugins({
      isProd
    }),
    new MiniCssExtractPlugin({
      filename: '[name].css'
    })
  ]
})

const buildProjectSkeletonConfig = ({
  jsEntries,
  assetHash,
  isProd,
  baseOutputDir,
  assetDir,
  assetHashTemplateReplacePath
}) => ({
  ...buildBaseConfig({
    isProd
  }),
  entry: {
    // Webpack needs an entry...
    [jsEntries[0] + '-omit']: path.join(jsBase, jsEntries[0] + '.js')
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
        from: publicPath,
        to: '..',
        transform: (content, pathname) => {
          if (assetHashTemplateReplacePath) {
            const fullPath = path.join(root, assetHashTemplateReplacePath)
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
    ])
  ]
})

module.exports = env => {
  const isProd = env.mode === 'production'
  const assetHash = env.assetHash
  const environment = env.environment
  const publicDest = env.publicDest
  const assetHashTemplateReplacePath = env.assetHashTemplateReplacePath

  // parses current .env file and provides all variables in process.env.XYZ
  // usage: process.env.APP_URL
  dotenv.config({
    path: path.join(base, '.env.' + environment)
  })

  const baseOutputDir = path.join(root, publicDest)
  const assetDir = baseOutputDir + '/' + assetHash
  const { jsEntries, cssEntries } = appConfiguration(env)

  const configObject = {
    baseOutputDir,
    assetDir,
    assetHash,
    assetHashTemplateReplacePath,
    isProd,
    jsEntries
  }

  return [
    buildProjectSkeletonConfig(configObject),
    ...jsEntries.map(jsEntry => buildJsConfig(jsEntry, configObject)),
    ...cssEntries.map(cssEntry => buildCssConfig(cssEntry, configObject))
  ]
}

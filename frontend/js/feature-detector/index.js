import createConfigurations from './config'

const configurations = createConfigurations()

function featureDetector(configurations) {
  for (let i in configurations) {
    const configuration = configurations[i]
    let { features, fallback, breaking = true } = configuration
    const unsupportedFeatures = features.filter(checkFeature => !checkFeature())
    const supported = unsupportedFeatures.length === 0
    fallback(supported)
    if (!supported && breaking) {
      break
    }
  }
}

featureDetector(configurations)

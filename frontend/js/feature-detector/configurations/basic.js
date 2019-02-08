import dataset from '../detects/js/dataset'
import bodyClassClickCookieFallback from '../fallbacks/body-class-click-cookie'

const basicConfig = {
  features: [dataset],
  fallback: bodyClassClickCookieFallback
}

export default basicConfig

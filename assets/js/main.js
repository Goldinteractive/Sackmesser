// shared variables for js and css
import * as SHARED from '../shared-variables'

// icons
import { Icon, IconManager } from 'gi-feature-icons'
// object-fit-images polyfill
import ObjectFitImage from 'gi-feature-object-fit-images'

// site features
import RandomQuote from './features/randomquote'


var app = {

  ui: {
    $window: $(window),
    $html: $('html'),
    $body: $('body'),
    $header: $('.layout-header'),
    $footer: $('.layout-footer')
  },

  eventHub: gi.eventHub,
  icons: null,
  scroll: null,
  device: null,

  init() {
    this
      .initIcons()
      .initScroller()
      .initDeviceInfo()
      .addFeatures()
      .initFeatures()
  },

  addFeatures() {
    // object-fit-images polyfill feature
    gi.features.add('fit', ObjectFitImage)
    gi.features.add('fit-watch', ObjectFitImage, { watchMQ: true })

    // site features
    gi.features.add('quote', RandomQuote, { count: 1 })

    return this
  },

  initFeatures() {
    gi.features.init(document.body)
    return this
  },

  initIcons() {
    this.icons = new IconManager({
      svgJsonFile: 'assets/icons.json',
      svgSpriteFile: 'assets/icons.svg'
    })

    this.icons.injectSprite(() => {
      this.icons.loadData(() => {
        gi.features.add('icon', Icon, { manager: this.icons })
        gi.features.init(document.body, 'icon')
      })
    })

    return this
  },

  initScroller() {
    this.scroll = new gi.utils.dom.Scroller()
    return this
  },

  initDeviceInfo() {
    this.device = new gi.utils.device.DeviceInfo({
      breakpoints: {
        small: SHARED['break-small'],
        medium: SHARED['break-medium'],
        large: SHARED['break-large']
      }
    })

    return this
  }

}

app.init()

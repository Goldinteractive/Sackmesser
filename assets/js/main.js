// shared variables for js and css
import * as SHARED from '../shared-variables'

// helpers
import { Scroller } from 'gi-js-base/src/utils/dom'
import { DeviceInfo } from 'gi-js-base/src/utils/device'

// icons
import { Icon, IconManager } from 'gi-feature-icons'
// object-fit polyfill
import ObjectFit from 'gi-feature-object-fit'

// site features
import RandomQuote from './features/randomquote'


var app = {

  ui: {
    $header: document.querySelector('.layout-header'),
    $footer: document.querySelector('.layout-footer')
  },

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
    gi.features.add('fit', ObjectFit)
    gi.features.add('fit-watch', ObjectFit, { watchMQ: true })

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
    this.scroll = new Scroller()
    return this
  },

  initDeviceInfo() {
    this.device = new DeviceInfo({
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

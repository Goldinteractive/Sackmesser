// shared variables for js and css
import * as SHARED from '../shared-variables'

// helpers
import { Scroller } from '@goldinteractive/js-base/src/utils/dom'
import { DeviceInfo } from '@goldinteractive/js-base/src/utils/device'

// icons
import { Icon, IconManager } from '@goldinteractive/feature-icons'
// object-fit polyfill
import ObjectFit from '@goldinteractive/feature-object-fit'

// site features
import RandomQuote from './features/randomquote'


var app = {

  ui: {
    $header: document.querySelector('.layout-header'),
    $footer: document.querySelector('.layout-footer')
  },

  icons: null,
  scroll: null,
  scrollWithHeaderOffset: null,
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

    // scroller with header as offset
    this.scrollWithHeaderOffset = new Scroller({
      offsetY: this.ui.$header.offsetHeight + 20
    })

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

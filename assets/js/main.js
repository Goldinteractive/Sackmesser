// shared variables for js and css
import * as SHARED from '../shared-variables'

// features
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
  scroll: null,
  device: null,

  init() {
    this
      .injectIconMarkup()
      .initScroller()
      .initDeviceInfo()
      .addFeatures()
      .initFeatures()
  },

  addFeatures() {
    gi.features.add('quote', RandomQuote, { count: 1 })
    return this
  },

  initFeatures() {
    gi.features.init()
    return this
  },

  injectIconMarkup() {
    var ajax = new XMLHttpRequest()

    ajax.open('GET', 'assets/icons.svg', true)
    ajax.send()
    ajax.onload = function(e) {
      var div = document.createElement('div')
      div.innerHTML = ajax.responseText
      document.body.insertBefore(div, document.body.childNodes[0])
    }

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

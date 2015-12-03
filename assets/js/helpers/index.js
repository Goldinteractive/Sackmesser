import SHARED from '../../shared-variables.json'

// private methods
var _compareViewportWidth = function(mode) {
  return window.innerWidth > window.parseInt(SHARED[mode])
}

/**
 * Calculate the outer width of any DOM element
 * @param   { DOMObject } el - DOM object we want to check
 * @returns { Number } - real width of the element containing the margin
 */
export function outerWidth(el, includeMargin = true) {
  var width = el.getBoundingClientRect().width,
    style

  if (includeMargin) {
    style = getComputedStyle(el)
    width += window.parseInt(style.marginLeft) + window.parseInt(style.marginRight)
  }

  return width
}


/**
 * requestAnimationFrame polyfill
 */
export const rAF = (function() {
  return  window.requestAnimationFrame       ||
          window.webkitRequestAnimationFrame ||
          window.mozRequestAnimationFrame    ||
          function( callback ) {
            window.setTimeout(callback, 1000 / 60)
          }
})()

// Returns a function, that, as long as it continues to be invoked, will not
// be triggered. The function will be called after it stops being called for
// N milliseconds. If `immediate` is passed, trigger the function on the
// leading edge, instead of the trailing.
export function debounce(func, wait, immediate) {
  var timeout
  return function() {
    var context = this, args = arguments
    var later = function() {
      timeout = null
      if (!immediate) func.apply(context, args)
    }
    var callNow = immediate && !timeout
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
    if (callNow) func.apply(context, args)
  }
}


/**
 * Css properties support
 * @type {Object}
 */
export const support = {
  transition: supportsCss('transition')
}

/**
 * Transition end event name
 * @type { String }
 */
export const transitionEnd =
  support.transition ?
    `${support.transition}end ${support.transition}End` : false


// check if the viewport is in mobile mode
export function isMobile() {
  return _compareViewportWidth('break-small')
}

// check if the viewport is in tablet mode
export function isTablet() {
  return _compareViewportWidth('break-medium')
}

// is this a touch device?
export function isTouch() {
  return 'ontouchstart' in window
}

// do I really need to explain what this is?
export function trim(string) {
  return string.replace(/^\s+|\s+$/gm, '')
}

/**
 * Check if any css property is supported
 * @param   { String } property - css property to test for example 'column-count'
 * @param   { String } value  - check whether a value is to a css property is supported
 * @returns { String|Array|Boolean } either only the property in camel case, or the property and its value
 * 4 ex:
 *   supportCss('column-count') => 'MozColumnCount'
 *   supportCss('column-count', '2') => ['MozColumnCount', '2']
 *   supportCss('position', 'sticky') => ['position', '-webkit-sticky']
 */
export function supportsCss(property, value) {
  var el = document.body || document.documentElement,
    style = el.style,
    cssProp,
    prop,
    // Tests for vendor specific prop
    prefixes = ['Webkit', 'Moz', 'ms', 'O', 'Khtml']

  // No css support detected
  if (typeof style == 'undefined') return false

  // normalize the property adding the prefixes
  property = (function(prop) {
    // Tests for standard prop
    if (typeof style[prop] == 'string') return prop

    prop = toCamel(prop.charAt(0).toUpperCase() + prop.substr(1))

    for (var i = 0; i < prefixes.length; i++) {
      if (typeof style[prefixes[i] + prop] == 'string') return  prefixes[i] + prop
    }

  })(property)

  // check only if the property is supported
  if (typeof value == 'undefined') {
    return property
  } else {
    // check the css value on a dummy dome element
    el = document.createElement('test')
    cssProp = `${toDash(property)}:`
    style = el.style

    prefixes = prefixes.map(str => `-${str.toLowerCase()}-`).concat([''])
    // add the value prefixed
    style.cssText = cssProp + prefixes.join( value + ';' + cssProp ) + value + ';'
    if (!style[ property ] || style[ property ].indexOf(value) == -1) return false
    else return [ property, style[ property ]]
  }

  return false
}


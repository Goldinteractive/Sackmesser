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
  transition: cssProperty('transition', true)
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

// check whether a css property is supported
export function cssProperty(p, rp) {
  var b = document.body || document.documentElement,
    s = b.style

  // No css support detected
  if (typeof s == 'undefined') { return false }

  // Tests for standard prop
  if (typeof s[p] == 'string') { return rp ? p : true }

  // Tests for vendor specific prop
  var v = ['Moz', 'Webkit', 'Khtml', 'O', 'ms', 'Icab']

  p = p.charAt(0).toUpperCase() + p.substr(1)

  for (var i = 0; i < v.length; i++) {
    if (typeof s[v[i] + p] == 'string') { return rp ? v[i] + p : true }
  }

  return false
}


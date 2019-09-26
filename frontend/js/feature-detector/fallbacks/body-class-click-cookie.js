/**
 * In case of an unsupported browser this will add a body className and register a click handler.
 * Upon clicking the button a cookie will be set to stop showing the information on subsequent loads.
 *
 * @param {boolean} support indicates whether the feature is supported
 */
const bodyClassNameFallback = support => {
  const COOKIE_NAME = 'browser-fallback-raised'
  const CLASS_NAME = '-browser-not-supported'
  const DISMISS_ID = 'dismiss-browser-not-supported'
  if (!support) {
    const alreadyDetected = document.cookie.indexOf(COOKIE_NAME) !== -1
    if (!alreadyDetected) {
      document.body.className += ' ' + CLASS_NAME
      const $element = document.getElementById(DISMISS_ID)
      if ($element !== null) {
        $element.onclick = function() {
          document.cookie = COOKIE_NAME + '=true'
          const reg = new RegExp('(\\s|^)' + CLASS_NAME + '(\\s|$)')
          document.body.className = document.body.className.replace(reg, ' ')
        }
      }
    }
  }
}

export default bodyClassNameFallback

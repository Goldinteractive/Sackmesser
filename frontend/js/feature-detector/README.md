# Feature Detector

Feature detector enables detecting browser features and using a fallback in case the application will not be properly running on a given environment.

## Configuration

Configuration can be done in `config.js` using a configuration preset in `configurations`.

Note that `config.js` is expected to return a function which generates an array of `configurations`.

A configuration object consists of the following structure:

```js
{
  features: [], // list of features to test
  fallback: bodyClassClickCookieFallback, // fallback strategy to invoke with parameter `supported`
  breaking: bool // indicator whether it should quit after the first not supported rule set
}
```

## Presets

Presets combine detectors and a fallback strategy.

## Detector

These scripts perform feature detection in the browser.

## Fallback

These scripts perform a given action based on whether the current environment is supported or not.

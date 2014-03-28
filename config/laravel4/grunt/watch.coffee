module.exports =
  js:
    files: ["public/assets/js/**/*.js"]
    tasks: ["jshint"]

  css:
    files: ["public/assets/scss/**/*.scss"]
    tasks: ["compass"]
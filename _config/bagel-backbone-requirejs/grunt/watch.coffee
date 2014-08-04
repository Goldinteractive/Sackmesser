module.exports =
  js:
    files: ["public/assets/js/**/*.js"]
    tasks: ["jshint"]

  tpl:
    files: ["public/assets/js/**/**/*.hbs"]
    tasks: ["handlebars"]

  css:
    files: ["public/assets/scss/**/*.scss"]
    tasks: ["compass"]
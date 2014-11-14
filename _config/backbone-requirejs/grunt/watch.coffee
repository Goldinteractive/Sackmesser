module.exports =
  js:
    files: ['assets/js/**/*.js']
    tasks: ['jshint']

  tpl:
    files: ['assets/js/**/**/*.hbs']
    tasks: ['handlebars']

  css:
    files: ['assets/scss/**/*.scss']
    tasks: ['compass']
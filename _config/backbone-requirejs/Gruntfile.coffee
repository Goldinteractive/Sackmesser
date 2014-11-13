module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  tasks = require("load-grunt-configs")(grunt,
    config:
      src: [
        "grunt/*.coffee"
        "grunt/*.js"
      ]
    pkg: grunt.file.readJSON("package.json")
    now: new Date().getTime()
    secret: grunt.file.readJSON(".ftppass")
  )

  grunt.initConfig tasks

  # Default task
  grunt.registerTask "default", [
    "jshint"
    "clean"
    "grunticon"
    "compass"
    "copy"
    "requirejs"
    "uglify"
    "filerev"
    "usemin"
    "clean:tmp"
  ]

  # Build the svg icons
  grunt.registerTask "build-icons", ["grunticon"]
  return
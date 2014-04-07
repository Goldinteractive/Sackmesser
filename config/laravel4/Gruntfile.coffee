module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  tasks = require("load-grunt-configs")(grunt,
    config:
      src: [
        "grunt/*.coffee"
        "grunt/*.js"
      ]
  )
  tasks.pkg = grunt.file.readJSON("package.json")
  tasks.now = new Date().getTime()
  tasks.secret = grunt.file.readJSON(".ftppass")
  grunt.initConfig tasks

  # Default task.
  grunt.registerTask "default", [
    "jshint"
    "clean:build"
    "grunticon"
    "copy"
    "useminPrepare"
    "concat"
    "uglify"
    "compass"
    "usemin"
    "clean:tmp"
  ]

  # Build the svg icons
  grunt.registerTask "build-icons", ["grunticon"]
  return
module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  tasks = require('load-grunt-configs')(grunt,
    config:
      src: [
        'grunt/*.coffee'
        'grunt/*.js'
      ]
    pkg: grunt.file.readJSON('package.json')
    now: new Date().getTime()
  )

  grunt.initConfig tasks

  # Default task
  grunt.registerTask 'default', [
    'jshint'
    'clean:build'
    'grunticon'
    'compass'
    'copy'
    'useminPrepare'
    'concat:generated'
    'cssmin:generated'
    'uglify:generated'
    'requirejs'
    'usemin'
    'clean:tmp'
  ]

  # Build the svg icons
  grunt.registerTask 'build-icons', ['grunticon']
  return
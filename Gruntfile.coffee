module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  tasks = require('load-grunt-configs')(grunt,
    config:
      src: [
        'tasks/*.coffee'
        'tasks/*.js'
      ]
    pkg: grunt.file.readJSON('package.json')
    now: new Date().getTime()
  )

  grunt.initConfig tasks

  # Default task.
  grunt.registerTask 'default', [
    'jshint'
    'clean:build'
    'grunticon'
    'sass'
    'copy'
    'useminPrepare'
    'concat:generated'
    'cssmin:generated'
    'uglify:generated'
    'usemin'
    'clean:tmp'
  ]

  # Build the svg icons
  grunt.registerTask 'build-icons', ['grunticon']

  # Watch and compile the scss files
  grunt.registerTask 'watch:sass', ['shell:sass-watch']
  grunt.registerTask 'sass', ['shell:sass-compile']
  return
module.exports = function(grunt) {

    require('load-grunt-tasks')(grunt);

    var tasks = require('load-grunt-configs')(grunt, {
            config: {
                src: ['grunt/*.coffee', 'grunt/*.js']
            }
        });

    tasks.pkg = grunt.file.readJSON('package.json');
    tasks.now = new Date().getTime();
    tasks.secret = grunt.file.readJSON('.ftppass');

    grunt.initConfig(tasks);

    // Default task.
    grunt.registerTask('default', ['jshint', 'clean', 'grunticon', 'compass', 'copy', 'requirejs', 'processhtml']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['grunticon']);

};
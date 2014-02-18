module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        watch: {
            js: {
                // watch all the changes in these files
                files: [
                    'assets/js/**/*.js'
                ],
                // parse the index.html to get all the js files to compile
                // and then it puts the generated file into the dist folder
                tasks: ['jshint']
            },
            tpl: {
                files: ['assets/js/**/**/*.hbs'],
                task: ['handlebars']
            },
            css: {
                // watch all the scss files
                files: [
                    'assets/scss/**/*.scss',
                ],
                tasks: ['compass']
            }
        },
        jshint: {
            all: ['Gruntfile.js', 'assets/js/**/*.js']
        },

        clean: {
            build: {
                src: ['dist']
            }
        },
        // copy all the useful files from the root to the dist folder
        copy: {
            main: {
                files: [{
                    // take the only the folders needed on the production server from the assets folde
                    expand: true,
                    cwd: 'assets',
                    src: ['css/**', 'img/**'],
                    dest: 'dist/assets'
                }, {
                    // take only the root files needed on the production server from the root
                    expand: true,
                    // exclude settings and config files
                    src: ['*.!(json|rb|md|js)'],
                    dest: 'dist',
                    filter: 'isFile'
                }],
            }
        },
        handlebars: {
            compile: {
                options: {
                    namespace: 'JST'
                },
                files: {
                    'assets/js/tmp/templates.js': [
                        'assets/js/**/**/*.hbs'
                    ],
                },
            }
        },
        processhtml: {
            build: {
                files: {
                    'dist/index.html': ['index.html']
                }
            }
        },
        requirejs: {
            build: {
                options: {
                    baseUrl: 'assets/js',
                    out: 'dist/assets/js/build.min.js',
                    mainConfigFile: 'assets/js/require-config.js',
                    name: '../vendor/almond/almond',
                    include: ['main'],
                    insertRequire: ['main'],
                    wrap: true
                }
            }
        },

        // create the css from the svg files
        grunticon: {
            myIcons: {
                files: [{
                    expand: true,
                    cwd: 'assets/img/icons/',
                    src: ['*.svg', '*.png'],
                    dest: "assets/css/iconsbuild/"
                }],
                options: {
                    cssprefix: "icon-"
                }
            }
        },
        // to generate all the favicons
        favicons: {
            options: {
                appleTouchBackgroundColor: '#ffffff',
                trueColor: true,
                html: 'favicons/favicons.html'
            },
            icons: {
                src: 'favicon-source.png',
                dest: 'favicons/'
            }
        },
        // build the scss files reading the compass config
        compass: {
            dist: {
                options: {
                    config: 'config.rb'
                }
            }
        }
    });

    require('load-grunt-tasks')(grunt);

    // Default task.
    grunt.registerTask('default', ['jshint', 'clean', 'grunticon', 'compass', 'copy', 'requirejs', 'processhtml']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['grunticon']);

};
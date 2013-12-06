module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        watch: {
            options: {
                livereload: true
            },
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
                files: ['assets/js/**/**/**/*.hbs'],
                tasks: ['handlebars']
            },
            css: {
                // watch all the scss files
                files: [
                    'assets/scss/**/*.scss',
                ],
                tasks: ['compass'],
            }
        },
        clean: {
            build: {
                src: ['dist']
            }
        },
        processhtml: {
            build: {
                files: {
                    'dist/templates/include/end.inc.php': ['templates/include/end.inc.php']
                }
            }
        },
        copy: {
            build: {
                files: [
                    // includes files within path
                    {
                        expand: true,
                        src: [
                            '*.!(json|rb|md|js)',
                            // obligatory folders
                            'assets/**',
                            'redaxo/**',
                            'templates/**',
                            // optional folders and files
                            // folders to exclude
                            '!redaxo/include/master.inc.php',
                            '!assets/js/**',
                            '!assets/scss/**',
                            '!assets/vendor/**'
                        ],
                        dest: 'dist/',
                        rename: function(dest, src) {
                            if (src === 'redaxo/include/master.inc.prod.php')
                                src = 'redaxo/include/master.inc.php';
                            return dest + src;
                        }
                    }
                ]
            }
        },
        jshint: {
            all: ['Gruntfile.js', 'assets/js/**/*.js']
        },
        // minifying all the svgs
        svgmin: { // Task
            options: { // Configuration that will be passed directly to SVGO
                plugins: [{
                    removeViewBox: true, // don't remove the viewbox atribute from the SVG
                    removeUselessStrokeAndFill: true, // don't remove Useless Strokes and Fills
                    removeEmptyAttrs: true
                }]
            },
            dist: { // Target
                files: [{ // Dictionary of files
                    expand: true, // Enable dynamic expansion.
                    cwd: 'assets/img/icons/', // Src matches are relative to this path.
                    src: ['*.svg'], // Actual pattern(s) to match.
                    dest: 'assets/img/icons/', // Destination path prefix.
                    ext: '.svg' // Dest filepaths will have this extension
                }]
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
        requirejs: {
            build: {
                options: {
                    baseUrl: 'assets/js',
                    out: 'dist/assets/js/build.min.js',
                    mainConfigFile: 'assets/js/config.js',
                    name: '../vendor/almond/almond',
                    optimize: 'uglify2',
                    include: ['main'],
                    insertRequire: ['main'],
                    findNestedDependencies: true,
                    preserveLicenseComments: false,
                    wrap: true
                }
            }

        },
        // create the css from the svg files
        grunticon: {
            myIcons: {
                options: {
                    src: "assets/img/icons/",
                    dest: "assets/css/iconsbuild/",
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
                src: 'favicon.png',
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
    grunt.registerTask('default', ['clean', 'svgmin', 'handlebars', 'grunticon', 'compass', 'copy', 'requirejs', 'processhtml']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['svgmin', 'grunticon']);

};
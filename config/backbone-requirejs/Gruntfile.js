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
                    namespace: 'JST',
                    processName: function(filePath) { // input:  templates/_header.hbs
                        var pieces = filePath.split('assets/js/templates/src/');
                        return pieces[pieces.length - 1]; // output: _header.hbs
                    }
                },
                files: {
                    'assets/js/tmp/templates.js': [
                        'assets/js/**/**/*.hbs'
                    ],
                },
            }
        },
        requirejs: {
            options: {
                baseUrl: 'assets/js',
                out: 'min/build.min.js',
                mainConfigFile: 'assets/js/config.js',
                name: '../vendor/almond/almond',
                include: ['main'],
                insertRequire: ['main'],
                wrap: true
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
        ftpscript: { // see https://npmjs.org/package/grunt-ftpscript, also: http://www.tech-step.net/?p=515
            staging: {
                // remember to setup correctly the .ftppass file
                options: {
                    host: 'sitehost.staging',
                    passive: false,
                    type: 'binary'
                },
                files: [{
                    expand: true,
                    cwd: './',
                    src: ['dist/**']
                }]
            },
            production: {
                // remember to setup correctly the .ftppass file
                options: {
                    host: 'sitehost.production',
                    passive: false,
                    type: 'binary'
                },
                files: [{
                    expand: true,
                    cwd: './',
                    src: ['dist/**']
                }]
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
    grunt.registerTask('default', ['svgmin', 'grunticon', 'compass']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['svgmin', 'grunticon']);

};
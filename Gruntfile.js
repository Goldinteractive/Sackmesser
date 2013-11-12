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
                tasks: ['useminPrepare', 'concat', 'uglify']
            },
            css: {
                // watch all the scss files
                files: [
                    'assets/scss/**/*.scss',
                ],
                tasks: ['compass']
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
        // parse the file (or the files containing the js files to build)
        // remember to wrap all the js files to build inside an html comment
        // 
        // <!-- build:js assets/js/main.min.js -->
        // <script src="js/app.js"></script>
        // <script src="js/controllers/thing-controller.js"></script>
        // <script src="js/models/thing-model.js"></script>
        // <script src="js/views/thing-view.js"></script>
        // <!-- endbuild -->
        // 
        //  THIS will become ...
        //  
        //                  |
        //                  |
        //                  |
        //                  |
        //                  |
        //                  V
        //                  
        // <script src="assets/js/main.min.js"></script>
        // 
        useminPrepare: {
            html: 'index.html',
            options: {
                dest: 'dist'
            }
        },
        // replace the html build comments with the right build js script
        // see above..
        usemin: {
            html: ['dist/index.html']
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
    grunt.registerTask('default', ['svgmin', 'grunticon', 'copy', 'useminPrepare', 'concat', 'uglify', 'compass', 'usemin']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['svgmin', 'grunticon']);

};
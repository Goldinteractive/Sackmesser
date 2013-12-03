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
                    'public/js/**/*.js'
                ],
                // parse the index.html to get all the js files to compile
                // and then it puts the generated file into the dist folder
                tasks: ['jshint']
            },
            css: {
                // watch all the scss files
                files: [
                    'public/scss/**/*.scss',
                ],
                tasks: ['compass']
            }
        },
        // remove the dist folder
        clean: {
          build: {
            src: ['dist']
          },
          tmp: {
            src: ['.tmp']
          }
        },
        // copy all the useful files from the root to the dist folder
        copy: {
            main: {
                files: [
                // take all the assets
                {
                    expand: true,
                    cwd: 'public',
                    src: ['**','.htaccess','!scss/**','!js/**','!vendor/**'],
                    dest: 'dist/public'
                },
                // take the right laravel core files
                {
                    expand: true,
                    src: ['app/**', 'bootstrap/**','vendor/**'],
                    dest: 'dist'
                },
                // take only the root files needed on the production server from the root
                {
                    expand: true,
                    // exclude settings and config files
                    src: ['*.!(json|rb|md|js|xml)','composer.json'],
                    dest: 'dist',
                    filter: 'isFile'
                }],
            }
        },
        jshint: {
            all: ['Gruntfile.js', 'public/js/**/*.js']
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
            html: 'app/views/layouts/base.blade.php',
            options: {
                root:'public',
                dest: 'dist'
            }
        },
        // replace the html build comments with the right build js script
        // see above..
        usemin: {
            html: ['dist/app/views/layouts/base.blade.php']
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
                    cwd: 'public/img/icons/', // Src matches are relative to this path.
                    src: ['*.svg'], // Actual pattern(s) to match.
                    dest: 'public/img/icons/', // Destination path prefix.
                    ext: '.svg' // Dest filepaths will have this extension
                }]
            }
        },
        // create the css from the svg files
        grunticon: {
            myIcons: {
                options: {
                    src: "public/img/icons/",
                    dest: "public/css/iconsbuild/",
                    cssprefix: "icon-"
                }
            }
        },
        // to generate all the favicons
        favicons: {
            options: {
                appleTouchBackgroundColor: '#ffffff',
                trueColor: true,
                html: 'public/favicons/favicons.html'
            },
            icons: {
                src: 'public/favicons/favicon.png',
                dest: 'public/favicons/'
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
    grunt.registerTask('default', ['clean:build','svgmin', 'grunticon', 'copy', 'useminPrepare', 'concat', 'uglify', 'compass', 'usemin','clean:tmp']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['svgmin', 'grunticon']);

};

module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        watch: {
            js: {
                // watch all the changes in these files
                files: [
                    'public/assets/js/**/*.js'
                ],
                // parse the index.html to get all the js files to compile
                // and then it puts the generated file into the dist folder
                tasks: ['jshint']
            },
            css: {
                // watch all the scss files
                files: [
                    'public/assets/scss/**/*.scss',
                ],
                tasks: ['compass']
            }
        },
        jshint: {
            all: [
                'Gruntfile.js',
                'public/assets/js/**/*.js'
            ]
        },
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
                files: [{
                    // take the only the folders needed on the production server from the public/assets folde
                    expand: true,
                    cwd: 'public',
                    src: [
                        'assets/css/**',
                        'assets/img/**',
                        'favicons/**',
                        'files/**',
                        'packages/**',
                        '*.txt',
                        '*.php'
                    ],
                    dest: 'dist/public/'
                }, {
                    // take only the root files needed on the production server from the root
                    expand: true,
                    // exclude settings and config files
                    src: [
                        'app/**',
                        'vendor/**',
                        'bootstrap/**',
                        '*.php'
                    ],
                    dest: 'dist',
                }],
            }
        },
        // parse the file (or the files containing the js files to build)
        // remember to wrap all the js files to build inside an html comment
        //
        // <!-- build:js public/assets/js/main.min.js -->
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
        // <script src="public/assets/js/main.min.js"></script>
        //
        useminPrepare: {
            html: 'app/templates/includes/scripts.blade.php',
            options: {
                dest: 'dist'
            }
        },
        // replace the html build comments with the right build js script
        // see above..
        usemin: {
            html: ['dist/app/templates/includes/scripts.blade.php']
        },

        // create the css from the svg files
        grunticon: {
            myIcons: {
                files: [{
                    expand: true,
                    cwd: 'public/assets/img/icons/',
                    src: ['*.svg', '*.png'],
                    dest: "public/assets/css/iconsbuild/"
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
                html: 'public/favicons/favicons.html'
            },
            icons: {
                src: 'public/favicons/favicon-source.png',
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
    grunt.registerTask('default', ['jshint','clean:build', 'grunticon', 'copy', 'useminPrepare', 'concat', 'uglify', 'compass', 'usemin','clean:tmp']);
    // Build the svg icons
    grunt.registerTask('build-icons', ['grunticon']);

};
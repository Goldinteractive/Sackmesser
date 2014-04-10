requirejs.config({
    paths: {
        jquery: '../vendor/bower/jquery/jquery',
        backbone: '../vendor/bower/backbone/backbone',
        underscore: '../vendor/bower/lodash/dist/lodash.underscore',
        layoutmanager: '../vendor/bower/layoutmanager/backbone.layoutmanager'
    },
    shim: {
        backbone: {
            deps: ['underscore','jquery'],
            exports: 'Backbone'
        },
        layoutmanager: ['backbone']
    }
});

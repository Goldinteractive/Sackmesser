requirejs.config({
    paths: {
        jquery: '../vendor/jquery/jquery',
        backbone: '../vendor/backbone/backbone',
        underscore: '../vendor/lodash/dist/lodash.underscore',
        layoutmanager: '../vendor/layoutmanager/backbone.layoutmanager'
    },
    shim: {
        backbone: {
            deps: ['underscore','jquery'],
            exports: 'Backbone'
        },
        layoutmanager: ['backbone']
    }
});

requirejs.config({
	urlArgs: new Date().getTime(),
	deps: ['main'],
	paths: {
		jquery: '../vendor/bower/jquery/dist/jquery',
		backbone: '../vendor/bower/backbone/backbone',
		underscore: '../vendor/bower/lodash/dist/lodash.underscore',
		layoutmanager: '../vendor/bower/layoutmanager/backbone.layoutmanager'
	},
	shim: {
		backbone: {
			deps: ['underscore', 'jquery'],
			exports: 'Backbone'
		},
		layoutmanager: ['backbone']
	}
});
require(['bootstrap'],function(){
	'use strict';
	require(['Router'],function(Router){
		// private vars
		var $window = $(window);
		/**
		 *
		 * Trigger a delayed resize window event being able to listen it from everywhere
		 *
		 */
		$window.on('resize orientationchange',_.debounce(function(){
			$window.trigger('viewport:update');
		},200));


		/**
		 * Init the app object and export it to the window
		 */
		window.app = {};

		/**
		 * Create the initialize function
		 */
		app.init = function () {
			app.router = new Router();
			Backbone.history.start();
		};

		// run the app
		app.init();

	});
});
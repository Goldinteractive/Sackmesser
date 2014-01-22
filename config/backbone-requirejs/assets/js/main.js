require([
	'require-config',
	'bootstrap'
],function(){
	'use strict';
	require(['Router'],function(Router){
		// private vars
		var $window = $(window);

		/**
		 * Init the app object and export it to the window
		 */
		window.app = {
			viewport: {
				width:0,
				height:0
			}
		};

		/**
		 * Create the initialize function
		 */
		app.init = function () {
			this.router = new Router();
			Backbone.history.start();
			this.setupViewport();
		};
		/**
		 * Function needed to cache the viewport size
		 */
		app.setupViewport = function () {
			app.viewport.width = $window.width();
			app.viewport.height = $window.height();

			$window.trigger('update');
		};

		/**
		 *
		 * Trigger a delayed resize window event being able to listen it from everywhere
		 *
		 */
		$window.on('resize orientationchange',_.debounce(app.setupViewport,200));
		// run the app
		app.init();

	});
});
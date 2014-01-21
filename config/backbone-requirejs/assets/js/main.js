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
			app.setupViewport();
			$window.trigger('viewport:update');
		},200));


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
			this.setupViewport();
			this.router = new Router();
			Backbone.history.start();
		};
		/**
		 * Function needed to cache the viewport size
		 */
		app.setupViewport = function () {
			this.viewport.width = $window.width();
			this.viewport.height = $window.height();
		};

		// run the app
		app.init();

	});
});
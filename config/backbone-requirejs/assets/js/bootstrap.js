/**
 * Setup all the scripts and the configuration before the app
 * gets initialized
 */

require(['backbone','layoutmanager'],function(){
	// Configure LayoutManager with Backbone Boilerplate defaults.
	Backbone.Layout.configure({
	    // Allow LayoutManager to augment Backbone.View.prototype.
	    manage: true,
	    fetchTemplate: function (path) {
	        // Concatenate the file extension.
	        path = path + ".hbs";

	        // If cached, use the compiled template.
	        if (JST[path]) {
	            return JST[path];
	        }
	        // Put fetch into `async-mode`.
	        var done = this.async();

	        // Seek out the template asynchronously.
	        $.get(path, function (contents) {
	            var tpl = Handlebars.compile(contents);
	            JST[path] = tpl;
	            done(tpl);
	        }, "text");
	    }
	});
});


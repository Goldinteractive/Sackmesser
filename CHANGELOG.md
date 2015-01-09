## Changelog

### v0.4.0
  * removed: __compass__ as dependency we now compile everything with sass that is a lot faster
  * added: grunt shell to compile and watch the scss directly with sass
  * added: the $breakpoints variable to make the grid and the respond-to calls more consistent and flexible
  * added: the `gem install sass-json-vars` dependency to load json files directly with sass
  * updated: the `grunt` folder now it's called `tasks` for a more consistent scaffold

### v0.3.1
  * updated: all the scss files will be installed using bower

### v0.3.0
  * removed: useless scss files
  * added: the brand new components framework compatibility

### v0.2.1
  * removed: grunt-filerev for an easier decache strategy
  * removed: removed useless files
  * updated: config.rb to parse Boolean, Numbers, and Strings

### v0.2.0
  * removed: useless ie conditionals from the templates
  * removed: grunt-processhtml using always grunt-usemin instead
  * removed: the `assets/scss/inlucde/animations` folder, we have rever used them
  * added: ``assets/shared-variables.json`` that is used in the scss files and it could be also loaded into the javascript files
  * added: grunt-filerev to decache the resource on every new project deployment
  * updated: README.md

### v0.1.9
  * updated: gird system - now it works also with the new Compass version (1.0.1) and it's backword compatible
  * added: Watezz to the team members

### v0.1.8
  * modified: config -> _config folder has been updated according to our new project setup standards

### v0.1.7
  * added: a brand new custom scss responsive grid system

### v0.1.6
  * updated: bower will fetch always inside the ``assets/vendor/bower`` folder, allowing the use of the ``assets/vendor`` folder also for other kind of third party libraries
  * updated: ``index.html`` cleaned up
  * updated: the __modernizr__ and __grunticon__ scripts will be loaded from the ``assets/vendor`` folder and compressed into a single file during the building process
  * updated: npm will fetch always the latest versions of the nodejs dependencies stored into ``package.json``

### v0.1.5
  * updated: all the nodejs grunt dependencies
  * updated: the grunt process has been split in separate coffeescript files

### v0.1.4
  * updated: all the nodejs grunt dependencies
  * updated: modernizr to 2.7.1
  * updated: humans.txt
  * updated: all the Gruntfile.js
  * added: ``config/bagel`` folder
  * removed: buttons stuff
  * removed: a lot of useless mixins and variables (please use the compass mixins instead http://compass-style.org/reference/compass/)
  * removed: the svgmin grunt dependency (never used)
  * removed: sackmesser logo (honestly it was really ugly)
  * removed: all the redaxo config folders
  * removed: jquery script link into index.html, install it using bower instead


### v0.1.3
  * feature: added jshint to all the build packages hoping that all the js files will never be a mess
  * added: ``config/backbone-requirejs`` folder build files
  * added: ``config/redaxo-backbone-requirejs`` folder build files
  * added: ``config/redaxo`` folder build files

### v0.1.2
  * added: ``config/latavel4`` folder build files

### v0.1.1
  * added: ``config`` folder to use several project setups

### v0.1.0
  * Sackmesser open sourced!
  * removed: all the jQuery.GI.* plugins, they will pulled from their own github repos

### v0.0.9
  * added: 'jQuery.OnePageScroll' plugin
  * added: grunt-favicons to generate all the favicons we need in any size for any device
  * added: grunt-ftpscript to deploy on the staging and/or production server
  * added: the shorthand to any css3 transition ease into the _variables.scss file

### v0.0.8

  * `jQuery.GI.Carousel.js` v0.1.8 (stable)
  * moved `assets/js/components` to `assets/vendor`
  * **new grunt build logic** using the `dist` folder to produce all the files that must be uploaded to production server
  * the `style.css` file produced using Compass will be ignored by default avoiding the annoying merge conflicts
  * all the vendor frameworks downloaded by **bower** are ignored by default and cannot be uploaded on the project repo use only **bower** to manage them ( ..so now also Sidney is Happy :) )
  * `codekit-config.json` has been removed because we don't use it anymore
  * **Matteo Patisso** has been removed from the `humans.txt` replaced by **Miro Bossert**
  * ...still looking for a better logo...

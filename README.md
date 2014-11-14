# Sackmesser

Before you start dealing with this package please make sure to have the latest [nodejs](http://nodejs.org/) version installed on your machine

## Before installing the frontend dependencies

Please select the right setup for your project from the ``_config`` folder.

If for example your project will use backbone and requirejs, just replace the files in the root with the config files contained into ``_config/backbone-requirejs/``.

The default files contained into the root folder can be useful just for a normal html project without too much ceremony.

__Attention__: the ``_config`` subfolders could contain also other kind of assets, in that case just replace the files needed for the new project setup for example:

``_config/backbone-requirejs/assets/js/`` -> ``assets/js``

Please once you have replaced the config files delete the ``_config`` folder

## Install all the dependencies
Just run the `$ sudo make` command into the root of this project to install all the dependencies.
If "make" command is not installed on your machine run following commands manually:

	$ npm i -g bower
	$ npm install
	$ npm i -g grunt-cli
	$ bower install

## Build the project
Thanks to [gruntjs](http://gruntjs.com/) we could easily reduce the time needed to build our project to bring it live.
The Gruntfile.js in this project provide us a list of command to build the scss files, compress the js and create the svg icons:

 * `$ grunt` this command triggers the default build action that could be different depending on the project. By default grunt builds the svg icons, processes the scss files and minifies the js creating the dist folder to upload)
 * `$ grunt build-icons` use this to build the svg icons
 * `$ grunt watch:css` with this cool trick the css gets updated anytime you change a scss file
 * `$ grunt watch:js` build and minify all the js files only when one of them gets changed or modified

## Install new grunt packages

### To install a node js module just type

```shell
	$ npm install yourmodule -save-dev
```

## jQuery plugins and js frameworks installation
Anytime you need to install a new jQuery plugin or either an utility you must do it using [bower](http://bower.io/).

If you have all the dependencies installed now you should be able to run the command:

```shell
	$ bower search
```

to find all the frameworks you could install through this tool.

Bower is designed to keep track of all the frameworks we are using in our project (jquery plugins, libraries and so on) so to install a new _"framework"_ just run es:

```shell
	$ bower install jquery -save
```

and it will add the new component into the folder set inside bower.json ( by default assets/vendor/bower )

## Good practices

> Don't think of cost. Think of value.

> Test it first before deploying it

## Changelog

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

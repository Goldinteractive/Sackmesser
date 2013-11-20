# Sackmesser v0.1.1 Stable
Before you start dealing with this package please make sure to have the latest [nodejs](http://nodejs.org/) version installed on your machine

## Before installing the frontend dependencies 

Please select the right setup for your project from the ``config`` folder. 
If for example your project will use backbone and requirejs, just replace the files in the root with the config files contained into ``config/backbone-requirejs/``. 
The default files contained into the root folder can be useful just for a normal html project without too much ceremony.

__Attention__: the ``config`` folders could contain also other ``assets``, in that case just replace the files needed for the new project setup for example:

``config/backbone-requirejs/assets/js/`` -> ``assets/js`` 

Please once you have replaced the config files please delete the ``config`` folder

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

 * `$ grunt` this command triggers the default build action that could be different depending on the project (by default this builds the svg icons, processes the scss files and minifies the js)
 * `$ grunt build-icons` use this to build the svg icons
 * `$ grunt watch:css` with this cool trick the css gets updated anytime you change a scss file
 * `$ grunt watch:js` build and minify all the js files only when one of them gets changed or modified

## Update and Install new grunt packages

### To install a node js module just type 

	$ npm install yourmodule --save-dev

### To update all the node js modules use

	$ npm update

## jQuery plugins and js frameworks installation
Anytime you need to install a new jQuery plugin or either an utility you must do it using [bower](http://bower.io/).

If you have all the dependencies installed now you should be able to run the command:

	$ bower search

to find all the frameworks you could install through this tool.

Bower is designed to keep track of all the frameworks we are using in our project (jquery plugins, libraries and so on) so to install a new _"framework"_ just run es:

	$ bower install jquery -save 

and it will add the new component into the folder set inside bower.json ( by default assets/vendor )

## Good practices

 * Please download the js libraries whether it is possible from sites like [cdnjs](http://cdnjs.com/)

## Changelog

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
  * **Matteo Patisso** has been removed from the `humans.txt` replaced with **Miro Bossert**
  * ...still looking for a better logo...

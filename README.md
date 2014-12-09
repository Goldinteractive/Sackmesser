# Sackmesser

## UI Components

- [buttons](http://goldinteractive.github.io/ui-buttons/)
- [grid](http://goldinteractive.github.io/ui-grid/)
- Effects
  - [material](http://goldinteractive.github.io/ui-effects-material/)

### How to install a component
To install a ui component just use `bower install gi-ui-[name of the component] -save` for example:

```shell
$ bower install gi-ui-buttons -save
```

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

### Scss

Please avoid the use of camel case variables in your scss files
```scss

// WRONG!
$buttonColor: #fff;

// GOOD!
$button-color: #fff;

```

> Don't think of cost. Think of value.

> Test it first before deploying it

# [Changelog](CHANGELOG.md)
# Sackmesser

![Sackmesser logo](sackmesser.png)

## Components

- [base](https://github.com/Goldinteractive/js-base): `gi-js-base`
- [grid](http://gridle.org/) `gridle`
- [jquery](https://jquery.com): `jquery`
- [sanitize.css](https://github.com/jonathantneal/sanitize.css): `sanitize.css`

## Features

- table: coming soon
- form: coming soon (replacing [form](http://goldinteractive.github.io/ui-form/))
- search: coming soon
- slider: coming soon (replacing [slider](http://goldinteractive.github.io/ui-slider/))
- gallery: coming soon
- map: coming soon
- accordion: coming soon
- pagination: coming soon
- tabs: coming soon
- overlay: coming soon ([overlay](http://goldinteractive.github.io/ui-overlay/))


### How to install a Gold Interactive component

To install a component just use `yarn install gi-ui-[name of the component] -save` for example:

```shell
$ yarn add gi-feature-table -save
```


### How to install other frontend frameworks

Bower is designed to keep track of all the frameworks we are using in our project (jquery plugins, libraries and so on) so to install a new framework just run es:

```shell
$ yarn add jquery
```
and it will add the new utility into the `node_modules` folder.


## Before installing the frontend dependencies

Please select the right setup for your project from the `frameworks-bootstrap` folder.
The default files contained into the root folder can be useful just for a normal html project without too much ceremony.

__Attention__: the `frameworks-bootstrap` subfolders could contain also other kind of assets, in that case just replace the files needed for the new project setup for example:

`frameworks-bootstrap/craft/.bowerrc` -> `.bowerrc`

Delete the `frameworks-bootstrap` folder, once you have replace the config files.


## Install all the dependencies

Use the `Makefile` to install all the current project dependencies (`bower`, `yarn` & `composer`):

```shell
$ make install
```


## Configure your machine to start working with Sackmesser (only the first time)

In Sackmesser we use several tools that must be installed on your machine before you will be able to work on a project. Once you are sure to have the latest [nodejs](http://nodejs.org/) and ruby on your machine, you can run the following command:

```shell
$ make setup
```


## Build the project

To build the project we need to use several command line tools and bash scripts. You can have a full list of all the available tasks by typing:

```shell
$ make
```

If you just want to build the project to bring it on the live site please use:

```shell
$ make build
```

All the build variables are stored in the `.config/build` file


#### References

- [rscss](http://rscss.io/)
- [sass-guidelines](http://sass-guidelin.es/)


# Other Links

- [Changelog](CHANGELOG.md)


# Deployment

- [Deployment README](.deployment/README.md)


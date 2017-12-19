# Sackmesser

![Sackmesser logo](sackmesser.png)

## Components

- [base](https://github.com/Goldinteractive/js-base): `gi-js-base`
- [grid](http://gridle.org/) `gridle`
- [jquery](https://jquery.com): `jquery`
- [sanitize.css](https://github.com/jonathantneal/sanitize.css): `sanitize.css`

## Available Features

- [icons](https://github.com/Goldinteractive/feature-icons) (installed by default)
- [object-fit](https://github.com/Goldinteractive/feature-object-fit) (installed by default)
- [slider](https://github.com/Goldinteractive/feature-slider)
- [gallery](https://github.com/Goldinteractive/feature-gallery)
- [accordion](https://github.com/Goldinteractive/feature-accordion)
- [form](https://github.com/Goldinteractive/feature-form)
- [select-search](https://github.com/Goldinteractive/feature-select-search)
- [map](https://github.com/Goldinteractive/feature-map)
- [modal](https://github.com/Goldinteractive/feature-modal)
- [image-zoom](https://github.com/Goldinteractive/feature-image-zoom)
- [overwrap](https://github.com/Goldinteractive/feature-overwrap)
- [datetime-picker](https://github.com/Goldinteractive/feature-datetime-picker)
- [touch-hover](https://github.com/Goldinteractive/feature-touch-hover)
- search: todo
- pagination: todo
- dropdown: todo
- tabs: todo
- slide-navigation: todo

### How to install a Gold Interactive component

To install a component just use `make feature-install-[name of the component]` for example:

```shell
$ make feature-install-datetime-picker
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


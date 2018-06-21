# Sackmesser

![Sackmesser logo](sackmesser.png)

## Components

- [base](https://github.com/Goldinteractive/js-base): `gi-js-base`
- [grid](http://gridle.org/) `gridle`
- [sanitize.css](https://github.com/jonathantneal/sanitize.css): `sanitize.css`


## Available Features

[Gold Features](https://github.com/Goldinteractive/gold-features) Checkout all features

### How to install a Gold Interactive component

To install a component just use `make feature-install-[name of the component]` for example:

```shell
$ make feature-install-datetime-picker
```


### How to install other frontend frameworks

Respect the proper scope of the dependency (runtime vs. compile time)

```shell
$ yarn add dependency-name
```
and it will add the new utility into the `node_modules` folder.

## Install all the dependencies

Use the `Makefile` to install all the current project dependencies (`yarn` & `composer`):

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


# Deployment

- [Deployment README](.deployment/README.md)


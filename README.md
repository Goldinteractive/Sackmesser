# Sackmesser

![Sackmesser logo](sackmesser.png)

Sackmesser provides the core of a web project. It contains configuration in order to get you started.
## Components

- [js-base](https://github.com/Goldinteractive/js-base): `@goldinteractive/js-base`

## Available Features

[Gold Features, checkout all features](https://github.com/Goldinteractive/gold-features)

### How to install a Gold Feature

To install a feature just use `make feature-install-[name of the component]` for example:

```shell
$ make feature-install-modal
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


## Configure your machine to start working with Sackmesser

Make sure you have Docker installed.

## Setup the Project

To setup the project you need to change the RECIPE in `build` to your corresponding project:

* default: Default project (Mostly static html or js app)
* craft: A project setup with Craft CMS
* laravel: A project for laravel

The recipe defined how a project is built and packaged for the deployment.

## Maintain the Project

To build the project we need to use several command line tools and bash scripts. You can have a full list of all the available tasks by typing:

```shell
$ make
```

Please note, that we encourage you to use Docker to develop. So you must always start a docker container before working on the project. To do so, simply execute:

```shell
$ make docker-up
```

All other command will automatically use the docker container instance, so in order to start working on the frontend, use:

```shell
$ make watch
```

If you want to work locally, you can do so by using the `Makefile.local`.

```shell
$ make -f Makefile.local watch
```

## Deployment

### Setup 
To setup the project for the deployment you need to edit the deployment configuration files
for each environment (production, staging …) you will use:

```
.config/deployment.*

* = environment (production, staging …)
```

### Deploy the Project

The deployment is handled by a CI server

So in order to deploy your changes to any environment simply commit them into the corresponding release branch.

The defaults are following branches:

* staging `release/staging`
* production `release/production`

The actual branches are dependent on the project and can change. 
Look in the .drone.yml file for the `branches` key. 

### Synchronize uploaded files

To synchronize uploaded files with an environment you have 2 actions:

```
# Push data to environment
make push-data-%

# Pull data from environment
make pull-data-%

# % = environment (production, staging …)
```
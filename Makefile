SHELL:=/bin/bash
-include .config/build
LOCALMAKEFILE:=Makefile.local
$(eval DOCKERCONTAINER_apache=$(shell sh -c "docker container ls -f name=$$(basename $$PWD)-apache --format '{{.Names}}'"))
$(eval DOCKERCONTAINER_frontend=$(shell sh -c "docker container ls -f name=$$(basename $$PWD)-frontend --format '{{.Names}}'"))
$(eval DOCKERCONTAINER_backend=$(shell sh -c "docker container ls -f name=$$(basename $$PWD)-backend --format '{{.Names}}'"))
$(eval DOCKERCONTAINER_designsystem=$(shell sh -c "docker container ls -f name=$$(basename $$PWD)-designsystem --format '{{.Names}}'"))

##################
# General
##################

help:
	@ $(SCRIPTS_FOLDER)/help.sh

.PHONY: install
install:
	@ make docker-make-exec SERVICE=backend CMD=install-be
	@ make docker-make-exec SERVICE=frontend CMD=install-fe

##################
# Frontend
##################

.PHONY: build-fe
build-fe:
	@ make docker-make-exec SERVICE=frontend CMD=build-fe

.PHONY: watch
watch:
	@ make install
	@ make favicons
	@ make icons
	@ make docker-make-exec SERVICE=frontend CMD=watch

.PHONY: feature-install-%
feature-install-%:
	@ make docker-make-exec SERVICE=frontend CMD=feature-install-$*

.PHONY: feature-remove-%
feature-remove-%:
	@ make docker-make-exec SERVICE=frontend CMD=feature-remove-$*

##################
# Design System
##################

.PHONY: watch-designsystem
watch-designsystem:
	@ make install
	@ docker compose restart designsystem
	@ make docker-make-exec SERVICE=designsystem CMD=watch-designsystem

.PHONY: build-designsystem
build-designsystem:
	@ make docker-make-exec SERVICE=designsystem CMD=build-designsystem

##################
# Icons
##################

.PHONY: icons
icons:
	@ make docker-make-exec SERVICE=frontend CMD=icons-optimize
	@ make docker-make-exec SERVICE=backend CMD=icons-compile

.PHONY: favicons
favicons:
	@ docker run \
	-v $(CURDIR):/src \
	-w /src \
	v4tech/imagemagick \
	$(SCRIPTS_FOLDER)/icons/favicons.sh $(FAVICONS_IN) $(FAVICONS_OUT)

##################
# Backend
##################

##################
# Docker
##################

.PHONY: up
up:
	@ docker compose up

.PHONY: stop
stop:
	@ docker compose stop

.PHONY: connect-%
connect-%:
	@ docker exec -i -t $(DOCKERCONTAINER_$*) bash

.PHONY: docker-make-exec
docker-make-exec:
	@ make docker-exec SERVICE=$(SERVICE) DOCKERCMD="make -f $(LOCALMAKEFILE) $(CMD)"

.PHONY: docker-exec
docker-exec:
	@ docker exec $(DOCKERCONTAINER_$(SERVICE)) $(DOCKERCMD)

##################
# Data
##################

.PHONY: pull-data-%
pull-data-%:
	@	DEPLOYENV=$* \
        SCRIPTS_FOLDER=$(SCRIPTS_FOLDER) \
        CONFIG_FOLDER=$(CONFIG_FOLDER) \
         $(SCRIPTS_FOLDER)/datasync/pull-data.sh

.PHONY: push-data-%
push-data-%:
	@	DEPLOYENV=$* \
        DEPLOY_SCRIPTS_FOLDER=$(SCRIPTS_FOLDER) \
        CONFIG_FOLDER=$(CONFIG_FOLDER) \
         $(SCRIPTS_FOLDER)/datasync/push-data.sh

SHELL:=/bin/bash
LOCALMAKEFILE:=Makefile.local
DOCKERAPPNAME=$(shell basename $(CURDIR))_app_1

-include .config/build

help:
	@ $(SCRIPTS_FOLDER)/help.sh

# docker proxy calls
.PHONY: install
install: 
	@ make docker-make-exec CMD=install

.PHONY: feature-install-%
feature-install-%:
	@ make docker-make-exec CMD=feature-install-$*

.PHONY: feature-remove-%
feature-remove-%:
	@ make docker-make-exec CMD=feature-remove-$*

.PHONY: watch
watch: 
	@ make docker-make-exec CMD=watch

.PHONY: icons
icons:
	@ make docker-make-exec CMD=icons

.PHONY: favicons
favicons:
	@ make docker-make-exec CMD=favicons

# docker 
.PHONY: docker-up
docker-up:
	@ docker-compose up

.PHONY: docker-connect
docker-connect:
	@ docker exec -i -t $(DOCKERAPPNAME) bash

.PHONY: docker-make-exec
docker-make-exec: 
	@ make docker-exec DOCKERCMD="make -f $(LOCALMAKEFILE) $(CMD)" 

.PHONY: docker-exec
docker-exec:
	@ docker exec -i -t $(DOCKERAPPNAME) $(DOCKERCMD)
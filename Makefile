SHELL:=/bin/bash
LOCALMAKEFILE:=Makefile.local
$(eval DOCKERAPPNAME=$(shell sh -c "docker container ls -f name=$$(basename $$PWD)_app_1 --format '{{.Names}}'"))

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

# dev machine
.PHONY: up
up:
	@ docker-compose up

.PHONY: connect
connect:
	@ docker exec -i -t $(DOCKERAPPNAME) bash

# docker 
.PHONY: docker-up
docker-up:
	@ make up

.PHONY: docker-connect
docker-connect:
	@ make connect

.PHONY: docker-make-exec
docker-make-exec: 
	@ make docker-exec DOCKERCMD="make -f $(LOCALMAKEFILE) $(CMD)" 

.PHONY: docker-exec
docker-exec:
	@ docker exec -i -t $(DOCKERAPPNAME) $(DOCKERCMD)

# data sync for files (legacy)
pull-data-%:
	@	DEPLOYENV=$* \
		SCRIPTS_FOLDER=$(SCRIPTS_FOLDER) \
		CONFIG_FOLDER=$(CONFIG_FOLDER) \
		 $(SCRIPTS_FOLDER)/datasync/pull-data.sh

push-data-%:
	@	DEPLOYENV=$* \
		DEPLOY_SCRIPTS_FOLDER=$(SCRIPTS_FOLDER) \
		CONFIG_FOLDER=$(CONFIG_FOLDER) \
		 $(SCRIPTS_FOLDER)/datasync/push-data.sh
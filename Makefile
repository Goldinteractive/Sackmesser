SHELL:=/bin/bash

-include .config/build

help:
	@ $(SCRIPTS_FOLDER)/help.sh

.PHONY: install
install: install-be install-fe

.PHONY: install-fe
install-fe:
	@ $(SCRIPTS_FOLDER)/frontend/install.sh

.PHONY: install-be
install-be:
	@ $(SCRIPTS_FOLDER)/backend/install.sh

.PHONY: feature-install-%
feature-install-%:
	# install feature
	@ yarn add @goldinteractive/feature-$*
	# copy feature assets
	@ rsync -r $(NODE_MODULES)/@goldinteractive/feature-$*/assets/features/* $(ASSETS_PATH)/features

.PHONY: feature-remove-%
feature-remove-%:
	# remove feature
	@ yarn remove @goldinteractive/feature-$*

.PHONY: watch
watch: install icons-optimize icons-generate watch-frontend

.PHONY: watch-frontend
watch-frontend:
	@ $(SCRIPTS_FOLDER)/frontend/watch.sh

.PHONY: build-local
build-local:
	@ ASSET_HASH=assets \
		PUBLIC_DEST=$(DEST) \
		ENVIRONMENT=production \
		.scripts/frontend/build.sh

.PHONY: icons
icons: icons-optimize icons-generate

.PHONY: icons-generate
icons-generate:
	# generate combined svg and json file with svg attribute informations
	@ php -f $(SCRIPTS_FOLDER)/frontend/icons/generate.php \
		sharedJson=$(FE_SOURCE)/shared-variables.json \
		iconsFolder=$(ICONS_OUT) \
		dataFileOutput=$(ICONS_DATA_FILE) \
		svgCombOutput=$(ICONS_COMBINED_SVG)

.PHONY: icons-optimize
icons-optimize:
	# optimize svg icons
	@ mkdir -p $(ICONS_OUT)
	@ $(SVGO) --pretty --disable=removeViewBox --folder $(ICONS_IN) --output $(ICONS_OUT)

.PHONY: favicons
favicons:
	@ $(SCRIPTS_FOLDER)/frontend/favicons.sh $(FAVICONS_IN) $(FAVICONS_OUT)

.PHONY: browser-sync
browser-sync:
	# starting browser sync server
	@ ASSETS_PATH=$(ASSETS_PATH) \
		TEMPLATES_PATH=$(TEMPLATES_PATH) \
		BROWSER=$(BROWSERSYNC_BROWSER) \
		$(BROWSERSYNC) start \
	    --config $(BROWSERSYNC_CONFIG) \
		--port $(BROWSERSYNC_PORT) \
		--proxy $(PROXY)

.PHONY: docker-up
docker-up:
	@ docker-compose up

.PHONY: docker-connect
docker-connect:
	@ docker exec -i -t $(shell basename $(CURDIR))_app_1 bash

# Import the build variables
-include .config/build
# Import the environment variables
-include .env

help:
	@ $(SCRIPTS_FOLDER)/help

build: clean js css copy

jsdoc:
	# generate js documentation
	@ jsdoc -r \
		-c $(JSDOC_CONFIG) \
		-d $(JSDOC_OUT) \
		-R $(JSDOC_README) \
		$(JSDOC_IN)

# Install all the project dependencies
# this may change in any project
install:
	@ $(SCRIPTS_FOLDER)/install

# compile the scss files
sass:
	# compile the normal css
	@ scss \
	    -I $(NODE_MODULES) \
		$(SCSS_IN)/style.scss:$(CSS_OUT)/style.scss.css \
		-r sass-json-vars

grid:
	# compile the grid
	@ scss \
	    -I $(NODE_MODULES) \
		$(SCSS_IN)/grid.scss:$(CSS_OUT)/grid.css \
		-r sass-json-vars

watch-grid:
	# watch the grid
	@ scss \
	    -I $(NODE_MODULES) \
		--style=compressed \
		--sourcemap=none \
		$(SCSS_IN)/grid.scss:$(CSS_OUT)/grid.css \
		-r sass-json-vars \
		--watch

# watch the scss files
watch-sass:
	@ scss \
	    -I $(NODE_MODULES) \
		$(SCSS_IN)/style.scss:$(CSS_OUT)/style.scss.css \
		-r sass-json-vars \
		--watch

postcss:
	# modify the normal css with postcss
	@ ASSETS_PATH=$(ASSETS_PATH) \
		$(POSTCSS) \
		--config $(POSTCSS_CONFIG) \
		$(CSS_OUT)/style.scss.css -o $(CSS_OUT)/style.css

watch-postcss:
	@ ASSETS_PATH=$(ASSETS_PATH) \
		$(POSTCSS) \
		--config $(POSTCSS_CONFIG) \
		$(CSS_OUT)/style.scss.css -o $(CSS_OUT)/style.css \
		--watch

css: grid sass postcss

watch-css:
	# compile the css on the fly
	@ $(SCRIPTS_FOLDER)/utils/parallel \
		"make watch-scss" \
		"make watch-postcss"

# check the js files
test:
	@ $(ESLINT) $(JS_BASE) --ignore-pattern=$(JS_BASE)/$(JS_OUT)

phpunit:
	# Not in use for right now
	# @ $(PHPUNIT) --bootstrap $(PHPUNIT_BOOTSTRAP) --configuration $(PHPUNIT_CONFIG) $(PHPUNIT_TESTDIR)

copy:
	@ ASSETS_PATH=$(ASSETS_PATH) \
		DEST=$(COPY_DEST) \
		JS_BASE=$(JS_BASE) \
		JS_OUT=$(JS_OUT) \
		$(SCRIPTS_FOLDER)/copy
	# replace the @TIMESTAMP variable
	@ egrep -lRZ "@TIMESTAMP" $(COPY_DEST) | xargs  sed -i '' "s/@TIMESTAMP/$(TIMESTAMP)/g"

clean:
	@ $(SCRIPTS_FOLDER)/clean

js:
	@ BASE=$(JS_BASE) \
		IN=$(JS_IN) \
		OUT=$(JS_OUT) \
		$(WEBPACK) \
		--config $(JS_CONFIG) \
		--display-error-details

watch-js:
	@ DEBUG=true WATCH=true $(MAKE) js

debug-js:
	@ DEBUG=true $(MAKE) js

icons: icons-generate icons-optimize

icons-generate:
	# generate combined svg and json file with svg attribute informations
	@ php -f $(SCRIPTS_FOLDER)/icons/generate.php \
		iconsFolder=$(ICONS_IN) \
		dataFileOutput=$(ICONS_DATA_FILE) \
		svgCombOutput=$(ICONS_COMBINED_SVG)

icons-optimize:
	# optimize svg icons
	@ svgo --pretty --folder $(ICONS_IN) --output $(ICONS_OUT)

browser-sync:
	# starting browser sync server
	@ ASSETS_PATH=$(ASSETS_PATH) \
		TEMPLATES_PATH=$(TEMPLATES_PATH) \
		BROWSER=$(BROWSERSYNC_BROWSER) \
		$(BROWSERSYNC) start \
	    --config $(BROWSERSYNC_CONFIG) \
		--port $(BROWSERSYNC_PORT) \
		--proxy $(PROXY)

watch:
	@ $(SCRIPTS_FOLDER)/utils/parallel \
		"make watch-js" \
		"make watch-scss" \
		"make watch-postcss"

setup:
	# setup your machine
	@ $(SCRIPTS_FOLDER)/utils/setup

favicons:
	@ $(SCRIPTS_FOLDER)/favicons $(FAVICONS_PATH)

# alias tasks
scss: sass
watch-scss: watch-sass

-include $(DEPLOY_SCRIPTS_FOLDER)/Makefile

.PHONY:
	install
	setup
	scss
	sass
	js
	grid
	debug-js
	watch
	watch-js
	watch-grid
	watch-sass
	watch-scss
	watch-css
	watch-postcss
	postcss
	favicons
	test
	phpunit
	build
	icons
	clean

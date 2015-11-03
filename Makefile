# Project constants
SCRIPTS_FOLDER=./tasks
WEBPACK=./node_modules/.bin/webpack
ESLINT=./node_modules/.bin/eslint
CLEANCSS=./node_modules/.bin/cleancss
POSTCSS=./node_modules/.bin/postcss
SVG_SPRITE=./node_modules/.bin/svg-sprite

# this could change in any project
ASSETS_PATH=assets
# set here the destination of your copy task
COPY_DEST=dist

# 90% of the times you should not change what's below

# Favicons path
FAVICONS_PATH=$(ASSETS_PATH)/favicons

# css
SCSS_IN=$(ASSETS_PATH)/scss
CSS_OUT=$(ASSETS_PATH)/css

# Icons
SRC_ICONS_PATH=$(ASSETS_PATH)/img/icons
OUT_ICONS_PATH=$(ASSETS_PATH)/css/iconsbuild

# js
JS_BASE=$(ASSETS_PATH)/js
JS_IN=main.js
JS_OUT=main.bundle.js
JS_CONFIG=tasks/webpack.config.js

help:
	@ $(SCRIPTS_FOLDER)/help

build: clean test js css copy

# Install all the project dependencies
# this may change in any project
install:
	@ $(SCRIPTS_FOLDER)/install

# compile the scss files
sass:
	# compile the normal css
	@ scss \
		--style=compressed \
		--sourcemap=none \
		$(SCSS_IN)/style.scss:$(CSS_OUT)/style.scss.css \
		-r sass-json-vars

grid:
	# compile the grid
	@ scss \
		--style=compressed \
		--sourcemap=none \
		$(SCSS_IN)/grid.scss:$(CSS_OUT)/grid.css \
		-r sass-json-vars

watch-grid:
	# watch the grid
	@ scss \
		--style=compressed \
		--sourcemap=none \
		$(SCSS_IN)/grid.scss:$(CSS_OUT)/grid.css \
		-r sass-json-vars \
		--watch

# watch the scss files
watch-sass:
	@ scss \
		--style=compressed \
		--sourcemap=none \
		$(SCSS_IN)/style.scss:$(CSS_OUT)/style.scss.css \
		-r sass-json-vars \
		--watch

postcss:
	# autoprefix the css
	@ $(POSTCSS) --use autoprefixer $(CSS_OUT)/style.scss.css -o $(CSS_OUT)/style.css

watch-postcss:
	@ $(POSTCSS) --use autoprefixer $(CSS_OUT)/style.scss.css -o $(CSS_OUT)/style.css --watch

cssmin:
	# optimize the css for the build
	@ $(CLEANCSS) $(CSS_OUT)/style.css -o $(CSS_OUT)/style.css

css: sass postcss grid cssmin

watch-css:
	# compile the css on the fly
	@ $(SCRIPTS_FOLDER)/utils/parallel \
		"make watch-scss" \
		"make watch-postcss"

# check the js files
test:
	@ $(ESLINT) $(JS_BASE) --ignore-pattern=$(JS_BASE)/$(JS_OUT)

copy:
	@ ASSETS_PATH=$(ASSETS_PATH) \
		DEST=$(COPY_DEST) \
		JS_BASE=$(JS_BASE) \
		JS_OUT=$(JS_OUT) \
		$(SCRIPTS_FOLDER)/copy

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

icons:
	@ grunticon $(SRC_ICONS_PATH) $(OUT_ICONS_PATH) --config=tasks/grunticonOptions

watch:
	@ $(SCRIPTS_FOLDER)/utils/parallel \
		"make watch-js" \
		"make watch-scss" \
		"make watch-postcss"

# setup your machine
setup:
	# install bower to manage the frontend dependencies
	@ $(SCRIPTS_FOLDER)/utils/setup

favicons:
	@ $(SCRIPTS_FOLDER)/favicons $(FAVICONS_PATH)

# alias tasks
scss: sass
watch-scss: watch-sass

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
	cssmin
	favicons
	test
	build
	icons
	clean


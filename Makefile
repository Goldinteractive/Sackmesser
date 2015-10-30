# Project constants
SCRIPTS_FOLDER=./tasks
WEBPACK=./node_modules/.bin/webpack
ESLINT=./node_modules/.bin/eslint
CLEANCSS=./node_modules/.bin/cleancss
SVG_SPRITE=./node_modules/.bin/svg-sprite

# this could change in any project
ASSETS_PATH=assets
# set here the destination of your copy task
COPY_DEST=dist

# 90% of the times you should not change what's below

# Favicons path
FAVICONS_PATH=$(ASSETS_PATH)/favicons

# css
SCSS_IN=$(ASSETS_PATH)/scss/style.scss
CSS_OUT=$(ASSETS_PATH)/css/style.css

# Icons
SRC_ICONS_PATH=$(ASSETS_PATH)/img/icons/*.svg
CSS_SPRITE_OUT_PATH=icons-sprite.svg
SASS_ICONS_FILE_OUT_PATH=../scss/base/icons/_sprite.scss

# js
JS_BASE=$(ASSETS_PATH)/js
JS_IN=main.js
JS_OUT=main.bundle.js
JS_CONFIG=tasks/webpack.config.js

build: clean test compile-js sass cssmin copy

# Install all the project dependencies
# this may change in any project
install:
	@ $(SCRIPTS_FOLDER)/install

# compile the scss files
sass:
	@ IN=$(SCSS_IN) \
		OUT=$(CSS_OUT) \
		$(SCRIPTS_FOLDER)/scss
# watch the scss files
watch-sass:
	@ IN=$(SCSS_IN) \
		OUT=$(CSS_OUT) \
		$(SCRIPTS_FOLDER)/scss --watch

# optimize the css for the build
cssmin:
	@ $(CLEANCSS) $(CSS_OUT) -o $(CSS_OUT)

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

compile-js:
	@ BASE=$(JS_BASE) \
		IN=$(JS_IN) \
		OUT=$(JS_OUT) \
		$(WEBPACK) \
		--config $(JS_CONFIG) \
		--display-error-details

js:
	@ DEBUG=true $(MAKE) compile-js

watch-js:
	@ DEBUG=true WATCH=true $(MAKE) compile-js

icons:
	@ $(SVG_SPRITE) -cD $(ASSETS_PATH)  \
		--mode-css-dest $(ASSETS_PATH) \
		--css-example \
		--css-prefix .icon- \
		--css-render-scss-dest $(SASS_ICONS_FILE_OUT_PATH) \
		--css-sprite $(CSS_SPRITE_OUT_PATH) \
		--css-render-scss \
		$(SRC_ICONS_PATH)

watch:
	@ $(SCRIPTS_FOLDER)/utils/parallel "make watch-js" "make watch-scss"

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
	watch-sass
	watch-scss
	js
	watch-js
	watch
	favicons
	test
	build
	cssmin
	icons
	clean
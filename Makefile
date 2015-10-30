# Project constants
SCRIPTS_FOLDER=./tasks/
WEBPACK=./node_modules/.bin/webpack
ESLINT=./node_modules/.bin/eslint

# Favicons path
FAVICONS_PATH=assets/favicons

# css
SCSS_IN=assets/scss/style.scss
CSS_OUT=assets/css/style.css

# js
JS_BASE=assets/js/
JS_IN=main.js
JS_OUT=main.bundle.js
JS_CONFIG=tasks/webpack.config.js

# Install all the project dependencies
# this may change in any project
install:
	@ $(SCRIPTS_FOLDER)install

# compile the scss files
sass:
	@ IN=$(SCSS_IN) \
		OUT=$(CSS_OUT) \
		$(SCRIPTS_FOLDER)scss
# watch the scss files
watch-sass:
	@ IN=$(SCSS_IN) \
		OUT=$(CSS_OUT) \
		$(SCRIPTS_FOLDER)scss --watch

js:
	@ BASE=$(JS_BASE) \
		DEBUG=true \
		IN=$(JS_IN) \
		OUT=$(JS_OUT) \
		$(WEBPACK) \
		--config $(JS_CONFIG) \
		--display-error-details

watch-js:
	@ BASE=$(JS_BASE) \
		DEBUG=true \
		IN=$(JS_IN) \
		OUT=$(JS_OUT) \
		$(WEBPACK) \
		--config $(JS_CONFIG) \
		--display-error-details \
		--watch

watch:
	@ $(SCRIPTS_FOLDER)utils/parallel "make watch-js" "make watch-scss"

# setup your machine
setup:
	# install bower to manage the frontend dependencies
	@ $(SCRIPTS_FOLDER)utils/setup

favicons:
	@ $(SCRIPTS_FOLDER)favicons $(FAVICONS_PATH)

# alias tasks
scss: sass
watch-scss: watch-sass

.PHONY: install setup scss sass watch-sass watch-scss js watch-js watch favicons
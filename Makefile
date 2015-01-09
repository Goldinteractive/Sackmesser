#Install all the package dependencies
install:
	# to compile the css
	gem install sass
	# to import the sass variables from a json file
	gem install sass-json-vars
	# to install the frontend dependencies
	npm install -g bower
	bower install --allow-root
	# to install the compile script dependencies
	npm install --save-dev
	npm install -g grunt-cli
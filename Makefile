#Install all the project dependencies
install:
	bower install
	sudo npm install

# setup your machine
setup:
	# to compile the css
	gem install sass
	# to import the sass variables from a json file
	gem install sass-json-vars
	# to install the frontend dependencies
	npm install -g bower
	# to install the compile script dependencies
	npm install -g grunt-cli
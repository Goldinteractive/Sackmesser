#Install all the package dependencies
install:
	sudo npm i -g bower
	sudo npm install --save-dev
	sudo npm i -g grunt-cli
	bower install --allow-root
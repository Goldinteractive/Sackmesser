module.exports =
	'sass-watch':
		command: 'sass --style=compressed --sourcemap=none --watch public/assets/scss/style.scss:public/assets/css/style.css -r sass-json-vars'
	'sass-compile':
		command: 'sass --style=compressed --sourcemap=none public/assets/scss/style.scss:public/assets/css/style.css -r sass-json-vars'

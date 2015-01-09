module.exports =
	'sass-watch':
		command: 'sass --style=compressed --sourcemap=none --watch assets/scss/style.scss:assets/css/style.css -r sass-json-vars'
	'sass-compile':
		command: 'sass --style=compressed --sourcemap=none assets/scss/style.scss:assets/css/style.css -r sass-json-vars'

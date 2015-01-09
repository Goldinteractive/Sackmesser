module.exports =
	html: [
		'dist/app/templates/include/start.blade.php'
		'dist/app/templates/include/scripts.blade.php'
	]
	options:
		blockReplacements:
			css: (block) ->
				'<link rel="stylesheet" href="' + block.dest + '?' + new Date().getTime() + '" />'
			js: (block) ->
				'<script src="' + block.dest + '?' + new Date().getTime() + '"></script>'
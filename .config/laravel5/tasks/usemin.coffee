module.exports =
	html: [
		'dist/resources/views/include/start.blade.php'
		'dist/resources/views/include/scripts.blade.php'
	]
	options:
		blockReplacements:
			css: (block) ->
				'<link rel="stylesheet" href="' + block.dest + '?' + new Date().getTime() + '" />'
			js: (block) ->
				'<script src="' + block.dest + '?' + new Date().getTime() + '"></script>'
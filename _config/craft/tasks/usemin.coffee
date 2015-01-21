module.exports =
	html: [
		'dist/craft/templates/_include/start.twig'
		'dist/craft/templates/_include/scripts.twig'
	]
	options:
		blockReplacements:
			css: (block) ->
				'<link rel="stylesheet" href="' + block.dest + '?' + new Date().getTime() + '" />'
			js: (block) ->
				'<script src="' + block.dest + '?' + new Date().getTime() + '"></script>'
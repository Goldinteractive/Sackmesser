module.exports =
	html: ['dist/index.html']
	options:
		blockReplacements:
			css: (block) ->
				'<link rel="stylesheet" href="' + block.dest + '?' + new Date().getTime() + '" />'
			js: (block) ->
				'<script src="' + block.dest + '?' + new Date().getTime() + '""></script>'
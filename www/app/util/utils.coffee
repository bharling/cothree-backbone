define [], () ->

	root = exports ? this

	# window resize from http://jeromeetienne.github.io/threex/
	WindowResize = (@renderer) =>
		@camera = null
		callback = =>
			renderer.setSize window.innerWidth, window.innerHeight
			if @camera?
				@camera.aspect = window.innerWidth / window.innerHeight
				@camera.updateProjectionMatrix
		window.addEventListener 'resize', callback, false
		ret = 
			setCamera: (camera) ->
				@camera = camera
			trigger: ->
				callback()
			destroy: ->
				window.removeEventListener 'resize', callback

	root.WindowResize = WindowResize
	root
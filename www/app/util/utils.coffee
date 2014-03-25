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
		{
			setCamera: (camera) ->
				@camera = camera
			trigger: ->
				callback()
			destroy: ->
				window.removeEventListener 'resize', callback
		}


	class Singleton
		@_instance = null
		@getInstance: ->
			@_instance or= new @( arguments... )


	class RingBuffer
		constructor: ( @max_items = 16 ) ->
			@head = 0
			@tail = 0
			@pending = (null for i in [0..@max_items])

		push : ( item ) =>
			if @tail >= max_items
				throw Error "Assertion Failed : too many items added to RingBuffer"
			@pending[@tail] = item
			@tail = (@tail + 1) % @max_items

		get : =>
			if @head == @tail
				return
			item = @pending[@head]
			@head = (@head + 1) % @max_items
			item


	{
		WindowResize: WindowResize
		Singleton: Singleton
		RingBuffer : RingBuffer
	}
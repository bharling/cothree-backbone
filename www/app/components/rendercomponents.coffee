define [], () ->

	root = exports ? this

	class Component
		update: (delta, now) =>

		destroy: =>



	class DemoCamera extends Component
		constructor: (@camera, @target) ->
			@mouse = x:0, y:0
			document.addEventListener 'mousemove', (event) =>
				@mouse.x = (event.clientX / window.innerWidth) - 0.5
				@mouse.y = (event.clientY / window.innerHeight) - 0.5
				true


		update: (delta, now) =>
			@camera.position.x += (@mouse.x*5 - @camera.position.x) / (delta*3)
			@camera.position.y += (@mouse.y*5 - @camera.position.y) / (delta*3)
			@camera.lookAt @target

	root.Component = Component
	root.DemoCamera = DemoCamera
	root

define [], () ->

	root = exports ? this

	class Component
		update: (delta, now) =>

		destroy: =>

	# adapted from : http://www.emagix.net/academic/mscs-project/item/camera-sync-with-css3-and-webgl-threejs
	class CSSRenderComponent extends Component
		constructor: (@camera, @domElement) ->
			@screenHalfWidth = window.innerWidth / 2
			@screenHalfHeight = window.innerHeight / 2
			@fovValue = 0.5 / Math.tan( @camera.fov * Math.PI / 360 ) * window.innerHeight
			@createDomElements()

		epsilon: (a) ->
			if Math.abs a < 0.000001
				return 0
			return a

		setCSSWorld: =>
			@divCSSWorld.style.WebkitPerspective = @fovValue + "px"
			@divCSSWorld.style.WebkitPerspectiveOrigin = "50% 50%"
			@divCSSWorld.style.MozPerspective = fovValue + "px"
			@divCSSWorld.style.MozPerspectiveOrigin = "50% 50%"

				

		createDomElements: =>
			@divCSSWorld = $ document.createElement 'div'
				.css
					position : "absolute"
					overflow : "hidden"
					"z-index" : 20,
					width : "100%"
					height : "100%"
					"-webkit-transform-style" : "preserve-3d"
					"-moz-transform-style" : "preserve-3d"
				appendTo @domElement


			@divCSSCamera = $(document.createElement 'div').prependTo @domElement

		setCSSCamera: =>
			cameraStyle = @getCSS3D_cameraStyle()
			@divCSSCamera.style.WebkitTransform = cameraStyle
			@divCSSCamera.style.MoxTransform = cameraStyle

		getCSS3D_cameraStyle: () =>
			"""
			translate3d(0,0, #{@epsilon @camera.fov}px)
			#{@toCSSMatrix @camera.matrixWorldInverse, true}
			 translate3d(#{@screenHalfWidth}px,#{@screenHalfHeight}px)
			"""

		update: (delta, now) =>



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

define [
	'jquery', 
	'underscore', 
	'backbone', 
	'three',
	'TweenLite',
	'cs!../util/geoms'
	], ($, _, Backbone, THREE, TweenLite, geoms) ->
	root = exports ? this

	

	class LoadingScreen
		constructor: ->
			@scene = new THREE.Scene
			@camera = new THREE.PerspectiveCamera 35, window.innerWidth / window.innerHeight, 1, 10000
			@camera.position.set 0,0,5
			@scene.add @camera
			@createDom()
			Backbone.on 'app:resourceLoaded', @updateProgress
				
		createDom: ->
			@circle = geoms.CircleMesh 64, 1
			@scene.add @circle
			@text = $ document.createElement 'div'
			@text.appendTo 'body'
			@text.css
				color : "#fff"
				position: "absolute"
				top : "0px"
				left : "0px"
				"z-index": 100
			@text.text "loading"


		updateProgress: (nLoaded, nTotal) =>
			message = "#{(nLoaded / nTotal) * 100}% done"
			console.log message
			@text.text message
			if nLoaded == nTotal
				@destroy()

		update: (delta, now) =>

		destroy: =>
			TweenLite.to @circle.scale, 0.5,
				x : 0.0
				y : 0.0
				z : 0.0
				ease: Quad.easeIn
				onComplete : @_remove

		_remove : =>
			Backbone.off 'app:resourceLoaded'
			Backbone.trigger 'app:popscene', @

		add: =>
			window.appEventDispatcher.trigger 'app:pushscene', @

	root.LoadingScreen = LoadingScreen
	root
define [
	'jquery', 
	'underscore', 
	'backbone', 
	'three',
	'cs!../components/rendercomponents', 
	'../util/threex.domevents'
	], ($, _, Backbone, THREE, rc, THREEx) ->
	root = exports ? this

	class LoadingScreen
		constructor: ->
			@scene = new THREE.Scene
			@camera = new THREE.PerspectiveCamera 35, window.innerWidth / window.innerHeight, 1, 10000
			@camera.position.set 0,0,5
			@scene.add @camera
			@createDom()
			window.appEventDispatcher.on 'app:resourceLoaded', @updateProgress
				
		createDom: ->
			@domElem = $ document.createElement "div"
				.css
					position : "absolute"
					top:"0px"
					left:"0px"
					background: "#ffaaaa"
					width: "100%"
					height: "100%"
					"text-align" : "center"
				.appendTo 'body'

			@loadingText = $ document.createElement "h2"
				.css
					color : "#fff"
				.text "Loafing : 0%"
				.appendTo @domElem


		updateProgress: (nLoaded, nTotal) =>
			console.log nLoaded
			@loadingText.text "#{(nLoaded / nTotal) * 100}% done"

		update: (delta, now) =>

		destroy: =>
			@domElem.remove()
			window.appEventDispatcher.off 'app:resourceLoaded'
			window.appEventDispatcher.trigger 'app:popscene', @

		add: =>
			window.appEventDispatcher.trigger 'app:pushscene', @



	class Scene
		constructor: ->
			@jsonLoader = new THREE.JSONLoader
			@textureLoader = new THREE.TextureLoader
			@components = []
			@toLoad = 0
			@numLoaded = 0
			@scene = new THREE.Scene
			@camera = null
			#@showLoadingScreen()
			@initialize()

		showLoadingScreen: =>
			@loadingScreen = new LoadingScreen
			@loadingScreen.add()

		allResourcesLoaded: =>


		## Load a JSON model from a filepath
		loadModel: (filePath, usserCallback) => 
			@toLoad++
			callBack = (geom, materials) =>
				new_mesh = new THREE.Mesh geom, new THREE.MeshFaceMaterial materials
				@numLoaded++
				usserCallback(new_mesh)
				window.appEventDispatcher.trigger "app:resourceLoaded", @numLoaded, @toLoad
				if @numLoaded == @toLoad
					@allResourcesLoaded()
					@loadingScreen.destroy()
			@jsonLoader.load filePath, callBack

		initialize: =>

		add: =>
			window.appEventDispatcher.trigger 'app:pushscene', @
			@showLoadingScreen()

		update: (delta, now) =>
			@components.forEach (component) ->
				component.update delta, now

		destroy: =>
			@.trigger 'app:popscene', @

	class DemoAnimatedLightComponent
		constructor: (@light) ->

		update: (delta, now) =>
			@light.position.x = Math.sin (now*0.0002) * 20.0


	class DemoScene extends Scene

		allResourcesLoaded: =>
			@scene.add @someText

		textLoaded: (mesh) =>
			@scene.add mesh
			mesh.position.x -= 1.9
			mesh.scale.set .8, .8, .8

		manLoaded: (mesh) =>
			@scene.add mesh


		initialize: =>
			@camera = new THREE.PerspectiveCamera 35, window.innerWidth / window.innerHeight, 1, 10000
			@camera.position.set 0,0,5
			@scene.add @camera
			@components.push new rc.DemoCamera @camera, new THREE.Vector3 0, 0, 0

			geom = new THREE.TorusGeometry 1, 0.45, 24, 16
			geom.computeFaceNormals()
			geom.computeVertexNormals(true)
			material = new THREE.MeshNormalMaterial
				shading:THREE.SmoothShading
			@mesh = new THREE.Mesh geom, material

			#@scene.add @mesh

			light = new THREE.PointLight 0xffffffff
			light.position.set -10, 20, 20
			@scene.add light

			@components.push new DemoAnimatedLightComponent light

			domEvents = new window.THREEx.DomEvents(@camera)
			domEvents.addEventListener @mesh, 'click', (event) =>
				@mesh.material.wireframe = not @mesh.material.wireframe

			@loadModel "app/resources/logo.mesh.js", @textLoaded
			@loadModel "app/resources/logo.mesh.js", @textLoaded
			#@loadModel "http://mrdoob.github.io/three.js/examples/obj/male02/Male02_dds.js", @manLoaded

	root.Scene = Scene
	root.DemoScene = DemoScene

	root
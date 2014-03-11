define ['jquery', 'underscore', 'backbone', 'three', 'cs!../components/rendercomponents', '../util/threex.domevents'], ($, _, Backbone, THREE, rc, THREEx) ->
	root = exports ? this




	class Scene
		constructor: ->
			@components = []
			@scene = new THREE.Scene
			@camera = null
			@initialize()

		initialize: =>


		add: =>
			window.appEventDispatcher.trigger 'app:pushscene', @

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

		addModelToScene: (geometry, materials) =>
			material = new THREE.MeshFaceMaterial materials
			logo = new THREE.Mesh(geometry, material)
			logo.scale.set 0.8, 0.8, 0.8
			#logo.rotation.x = Math.PI / 2
			logo.position.x -= 1.9
			#logo.position.y += 0.5
			@scene.add logo



		loadModel: =>
			jsonLoader = new THREE.JSONLoader()
			jsonLoader.load "app/resources/logo.mesh.js", @addModelToScene

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

			@loadModel()






	root.Scene = Scene
	root.DemoScene = DemoScene

	root
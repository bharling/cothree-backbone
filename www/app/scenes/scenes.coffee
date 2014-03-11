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


	class DemoScene extends Scene

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

			@scene.add @mesh

			domEvents = new window.THREEx.DomEvents(@camera)
			domEvents.addEventListener @mesh, 'click', (event) =>
				@mesh.material.wireframe = not @mesh.material.wireframe






	root.Scene = Scene
	root.DemoScene = DemoScene

	root
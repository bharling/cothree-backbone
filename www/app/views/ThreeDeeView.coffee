define ['jquery', 'underscore', 'backbone', 'three'], 
( $, _, Backbone, THREE) ->
	root = exports ? this

	class ThreeDeeModel extends Backbone.Model


		initialize: ->
			@init3D()

		init3D: =>
			geom = new THREE.TorusGeometry 1, 0.45
			material = new THREE.MeshNormalMaterial
			@mesh = new THREE.Mesh geom, material

	class ThreeDeeModelCollection extends Backbone.Collection
		model = ThreeDeeModel


	# window resize from http://jeromeetienne.github.io/threex/
	WindowResize = (renderer, camera) ->
		callback = ->
			renderer.setSize window.innerWidth, window.innerHeight
			camera.aspect = window.innerWidth / window.innerHeight
			camera.updateProjectionMatrix
		window.addEventListener 'resize', callback, false
		ret = 
			trigger: ->
				callback()
			destroy: ->
				window.removeEventListener 'resize', callback
		


	class MainThreeDeeView extends Backbone.View
		el : $ 'body'

		debugGeom: =>
			item = new ThreeDeeModel()
			@collection.add item

		addItem: (item) =>
			@scene.add item.mesh

		initialize: ->
			@collection = new ThreeDeeModelCollection
			@collection.bind 'add', @addItem

			@renderer = new THREE.WebGLRenderer antialias: true, preserveDrawingBuffer: true
			@renderer.setSize window.innerWidth, window.innerHeight

			@scene = new THREE.Scene()
			@camera = new THREE.PerspectiveCamera 35, window.innerWidth / window.innerHeight, 1, 10000

			@camera.position.set 0,0,5
			@scene.add @camera

			@windowResize = new WindowResize @renderer, @camera

			#@debugGeom()

			@render()

		renderScene: =>
			requestAnimationFrame @renderScene
			@renderer.render @scene, @camera

		render: ->
			$(@el).empty().append @renderer.domElement
			@renderScene()

	root.MainThreeDeeView = MainThreeDeeView
	root
define ['jquery', 'underscore', 'backbone', 'three', 'cs!../models/models', 'cs!../util/utils', 'cs!../components/rendercomponents'], 
( $, _, Backbone, THREE, models, utils, rc) ->
	root = exports ? this

	class @EventDispatcher
		constructor: ->
			_.extend @, Backbone.Events

	@appEventDispatcher = new EventDispatcher()


	class MainThreeDeeView extends Backbone.View
		el : $ 'body'

		debugGeom: =>
			item = new models.ThreeDeeModel
			@collection.add item

		addItem: (item) =>
			@scene.add item.mesh

		pushScene: (scene) =>
			@scenes.push scene
			@currentScene = scene

		popScene: => 
			if @scenes.length > 1
				@scenes.pop()
				@currentScene = scenes[-1..]

		initialize: ->
			@scenes = []
			@currentScene = null
			@collection = new models.ThreeDeeModelCollection
			@collection.bind 'add', @addItem
			@lastTime = 0
			@renderer = new THREE.WebGLRenderer antialias: true, preserveDrawingBuffer: true
			@renderer.setSize window.innerWidth, window.innerHeight
			window.appEventDispatcher.on 'app:pushscene', (scene) =>
				@pushScene(scene)

			window.appEventDispatcher.on 'app:popscene', () =>
				@popScene()

			@windowResize = new utils.WindowResize @renderer, @camera
			@render()

		renderScene:(now) =>
			requestAnimationFrame @renderScene

			now ?= 1000/60

			@lastTime = @lastTime ? now - 1000/60
			delta = Math.min 200, now - @lastTime
			@lastTime = now

			if @currentScene
				@currentScene.update(delta, now)
				@renderer.render @currentScene.scene, @currentScene.camera

		render: ->
			$(@el).empty().append @renderer.domElement
			@renderScene()

	root.MainThreeDeeView = MainThreeDeeView
	root
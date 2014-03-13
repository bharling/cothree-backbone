define ['jquery', 'underscore', 'backbone', 'three', 'cs!../models/models', 'cs!../util/utils', 'cs!../components/rendercomponents', 'cs!../scenes/loading.coffee'], 
( $, _, Backbone, THREE, models, utils, rc, loading) ->
	root = exports ? this

	class MainThreeDeeView extends Backbone.View
		el : $ 'body'

		debugGeom: =>
			item = new models.ThreeDeeModel
			@collection.add item

		addItem: (item) =>
			@scene.add item.mesh

		pushScene: (scene) =>
			@scenes.push scene
			@scenes.push @loadingScreen
			@currentScene = @loadingScreen
			@windowResize.setCamera scene.camera

		popScene: => 
			if @scenes.length > 1
				@scenes.pop()
				@currentScene = @scenes[-1..][0]
				@windowResize.setCamera @currentScene.camera

		initialize: ->
			@scenes = []
			@currentScene = null
			@loadingScreen = new loading.LoadingScreen
			@lastTime = 0
			@renderer = new THREE.WebGLRenderer antialias: true, preserveDrawingBuffer: true
			@renderer.setSize window.innerWidth, window.innerHeight
			Backbone.on 'app:pushscene', (scene) =>
				@pushScene(scene)

			Backbone.on 'app:popscene', () =>
				@popScene()

			@windowResize = new utils.WindowResize @renderer, @camera
			@render()

		renderScene:(now) =>
			requestAnimationFrame @renderScene

			now ?= 1000/60

			@lastTime = @lastTime ? now - 1000/60
			delta = Math.min 200, now - @lastTime
			@lastTime = now

			if @currentScene?
				@currentScene.update(delta, now)
				@renderer.render @currentScene.scene, @currentScene.camera

		render: ->
			$(@el).append @renderer.domElement
			@renderScene()

	root.MainThreeDeeView = MainThreeDeeView
	root
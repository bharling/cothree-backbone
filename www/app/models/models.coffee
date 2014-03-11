define ['jquery', 'underscore', 'backbone', 'three'], ($, _, Backbone, THREE) ->
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

	root.ThreeDeeModel = ThreeDeeModel
	root.ThreeDeeModelCollection = ThreeDeeModelCollection
	root
	
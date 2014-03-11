define ['three'], (THREE) ->
	root = exports ? this

	class DomEvents
		constructor: (camera, domElement) ->
			@_camera = camera ? null
			@_domElement = domElement ? document
			@_projector = new THREE.Projector()
			@_selected = null
			@_boundObjs = null
define ['three'], (THREE) ->

	CircleMesh = (segments, radius, material) ->

		material ?= new THREE.MeshBasicMaterial
			color : 0xFFFFFF

		geometry = new THREE.Geometry

		geometry.vertices.push new THREE.Vector3 0, 0, 0

		ind = 0

		for i in [0..segments]
			theta = (i/segments) * Math.PI * 2
			geometry.vertices.push new THREE.Vector3 Math.cos(theta) * radius, Math.sin(theta) * radius, 0

		for i in [1..segments]
			geometry.faces.push new THREE.Face3 0, i, i+1



		new THREE.Mesh geometry, material

	{
		CircleMesh
	}

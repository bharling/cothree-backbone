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



	class Grass
		constructor: (@size = 4.0, @tileCount = 8, @density=24, @grassSize=0.2) ->
			@build()

		build: ( size, tileCount ) ->
			@baseGeom = new THREE.Geometry
			tile_size = @size / @tileCount

			tile_geom = new THREE.Geometry
			for p in [0..@density]
				x = Math.random() * tile_size
				z = Math.random() * tile_size
				g = @buildGrassGeom( x, z )
				THREE.GeometryUtils.merge(tile_geom, g)

			THREE.GeometryUtils.merge( @baseGeom, tile_geom )

			for x in [0..@tileCount]
				for y in [0..@tileCount]
					g = tile_geom.clone()
					_x = x * @size
					_y = y * @size
					g.applyMatrix new THREE.Matrix4().makeTranslation( new THREE.Vector3( _x, 0, _y ) )
					THREE.GeometryUtils.merge( @baseGeom, g )
					console.log( @baseGeom.vertices.length )

			@material = new THREE.MeshNormalMaterial({wireframe:true})
			@mesh = new THREE.Mesh( @baseGeom, @material )




		buildGrassGeom: (x, y) =>
			# build a cross shaped geometry of 2 planes
			# normals always point straight up for all vertices
			vnormal = new THREE.Vector3 0.0, 1.0, 0.0
			geom = new THREE.Geometry

			half_size = @grassSize / 2.0

			# Build the first plane
			v1 = new THREE.Vector3( -half_size, 0.0, 0.0 )
			v2 = new THREE.Vector3( half_size, 0.0, 0.0 )
			v3 = new THREE.Vector3( half_size, @grassSize, 0.0 )
			v4 = new THREE.Vector3( -half_size, @grassSize, 0.0 )
			uva = new THREE.Vector2( 0.0, 0.0 )
			uvb = new THREE.Vector2( 1.0, 0.0 )
			uvc = new THREE.Vector2( 1.0, 1.0 )
			uvd = new THREE.Vector2( 0.0, 1.0 )
			geom.vertices.push( v1 )
			geom.vertices.push( v2 )
			geom.vertices.push( v3 )
			geom.vertices.push( v4 )
			face = new THREE.Face3( 0, 1, 2 )
			face.vertexNormals.push( vnormal.clone(), vnormal.clone(), vnormal.clone())
			geom.faces.push( face )
			geom.faceVertexUvs[0].push([ uva, uvb, uvc ])
			face = new THREE.Face3( 2, 3, 0 )
			face.vertexNormals.push( vnormal.clone(), vnormal.clone(), vnormal.clone())
			geom.faces.push( face )
			geom.faceVertexUvs[0].push([uvb.clone(), uvc.clone(), uvd])


			# Build the second plane
			v1 = new THREE.Vector3( 0.0, 0.0, -half_size )
			v2 = new THREE.Vector3( 0.0, 0.0, half_size )
			v3 = new THREE.Vector3( 0.0, @grassSize, half_size )
			v4 = new THREE.Vector3( 0.0, @grassSize, -half_size )
			uva = new THREE.Vector2( 0.0, 0.0 )
			uvb = new THREE.Vector2( 1.0, 0.0 )
			uvc = new THREE.Vector2( 1.0, 1.0 )
			uvd = new THREE.Vector2( 0.0, 1.0 )
			geom.vertices.push( v1 )
			geom.vertices.push( v2 )
			geom.vertices.push( v3 )
			geom.vertices.push( v4 )
			face = new THREE.Face3( 0+4, 1+4, 2+4 )
			face.vertexNormals.push( vnormal.clone(), vnormal.clone(), vnormal.clone())
			geom.faces.push( face )
			geom.faceVertexUvs[0].push([ uva, uvb, uvc ])
			face = new THREE.Face3( 2+4, 3+4, 0+4 )
			face.vertexNormals.push( vnormal.clone(), vnormal.clone(), vnormal.clone())
			geom.faces.push( face )
			geom.faceVertexUvs[0].push([uvb.clone(), uvc.clone(), uvd])


			# 'Bake' in a random rotation
			
			geom.computeCentroids()


			transmat = new THREE.Matrix4().makeTranslation(  x, 0, y )


			geom.applyMatrix transmat

			
			geom.applyMatrix new THREE.Matrix4().makeRotationY( Math.random() * (Math.PI * 2))
			return geom

	{
		Grass : Grass
		ThreeDeeModel : ThreeDeeModel
		ThreeDeeModelCollection : ThreeDeeModelCollection
	}
	
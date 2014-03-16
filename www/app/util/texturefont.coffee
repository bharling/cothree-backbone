define ['three'], (THREE) ->

	root = exports ? this

	class TextureFont

		constructor : () ->
			@jsonLoader = new THREE.XHRLoader

		loadFont : (fontFile, @onFontLoadCallback) =>
			@jsonLoader.load( fontFile, @onJsonLoaded )

		onJsonLoaded : (fontData) =>
			@fontData = JSON.parse( fontData )
			#@fontTexture = THREE.ImageUtils.loadTexture @fontData.texture, {}, @onTextureLoaded
			@material = new THREE.MeshBasicMaterial 
				map : THREE.ImageUtils.loadTexture @fontData.texture 
				sided : THREE.DoubleSide
				#wireframe : true
			#@material = new THREE.MeshBasicMaterial color:0xffffffff
			@onFontLoadCallback()


		renderChar : (geom, chr, x, y ) =>
			console.log(chr)
			char_data = @fontData.charmap[chr]
			idx = geom.vertices.length
			face_index = geom.faces.length
			vd = char_data.verts
			ud = char_data.uvs

			console.log ud

			geom.vertices.push new THREE.Vector3 x + vd[0], y + vd[1], vd[2]
			geom.vertices.push new THREE.Vector3 x + vd[3], y + vd[4], vd[5]
			geom.vertices.push new THREE.Vector3 x + vd[6], y + vd[7], vd[8]
			geom.vertices.push new THREE.Vector3 x + vd[9], y + vd[10], vd[11]

			###
			3------2
			|	   |
			|      |
			0------1
			###

			geom.faces.push new THREE.Face3 idx, idx+2, idx+3
			geom.faces.push new THREE.Face3 idx, idx+1, idx+2

			
			uvs = [
				new THREE.Vector2 ud[0], ud[1] 
				new THREE.Vector2 ud[2], ud[3] 
				new THREE.Vector2 ud[4], ud[5]
				new THREE.Vector2 ud[6], ud[7]
			]
			

			geom.faceVertexUvs[0].push [
				uvs[0], uvs[2], uvs[3]
				#new THREE.Vector2( 0, 0 )
				#new THREE.Vector2( 1, 1 )
				#new THREE.Vector2( 0, 1 )
			]

			geom.faceVertexUvs[0].push [
				uvs[0], uvs[1], uvs[2]
				#new THREE.Vector2( 0, 0 )
				#new THREE.Vector2( 1, 0 )
				#new THREE.Vector2( 1, 1 )
			]


			###
			geom.faceVertexUvs[ 0 ].push [
			    new THREE.Vector2( ud[0], ud[1] )
			    new THREE.Vector2( ud[2], ud[3] )
				new THREE.Vector2( ud[4], ud[5] )    
			]

			geom.faceVertexUvs[ 0 ].push [
				new THREE.Vector2( ud[2], ud[3] )
				new THREE.Vector2( ud[4], ud[5] )
				new THREE.Vector2( ud[6], ud[7] )    
			] 
			###

			#geom.faceVertexUvs[0].push([uvs[1], uvs[0], uvs[2]])
			#geom.faceVertexUvs[0].push([uvs[2], uvs[0], uvs[3]])


		renderText : (textString) =>
			len = textString.length - 1
			x = y = 0.0
			geom = new THREE.Geometry
			geom.faceVertexUvs[0] = []
			for i in [0..len]
				ch = textString.charAt(i)
				@renderChar geom, ch, x, y
				x += @fontData.charmap[ch].width
			new THREE.Mesh geom, @material

	root.TextureFont = TextureFont
	root

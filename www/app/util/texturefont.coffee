define ['three'], (THREE) ->

	root = exports ? this

	class TextureFont

		constructor : () ->
			@jsonLoader = new THREE.XHRLoader

		loadFont : (fontFile, @onFontLoadCallback) =>
			@jsonLoader.load( fontFile, @onJsonLoaded )

		onJsonLoaded : (fontData) =>
			@fontData = JSON.parse( fontData )
			@fontTexture = THREE.ImageUtils.loadTexture @fontData.texture, {}, @onTextureLoaded

		onTextureLoaded: (event) =>
			@material = new THREE.MeshLambertMaterial( map : @fontTexture )

		renderChar : (geom, chr, x, y ) =>
			char_data = @fontData.charmap[chr]
			idx = geom.vertices.length
			face_index = geom.faces.length
			vd = char_data.verts
			ud = char_data.uvs

			geom.vertices.push new THREE.Vector3 x + vd[0], y + vd[1], 0
			geom.vertices.push new THREE.Vector3 x + vd[3], y + vd[4], 0
			geom.vertices.push new THREE.Vector3 x + vd[6], y + vd[7], 0
			geom.vertices.push new THREE.Vector3 x + vd[9], y + vd[10], 0

			geom.faces.push new THREE.Face3 idx, idx+1, idx+2
			geom.faces.push new THREE.Face3 idx+2, idx+3, idx

			geom.faceVertexUvs[0].push [
				new THREE.Vector2 ud[0], ud[1]
				new THREE.Vector2 ud[2], ud[3]
				new THREE.Vector2 ud[4], ud[5]
				new THREE.Vector2 ud[6], ud[7]
			]








		renderText : 
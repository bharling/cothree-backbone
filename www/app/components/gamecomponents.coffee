define ['jquery', 'underscore', 'backbone','three'], ( $, _, Backbone, THREE ) ->

	###
	GameObject 'container'
	###
	class GameObject
		constructor: ->
			@components = []
			@position = new THREE.Vector3()
			@bounds = new THREE.Box3()

		send : (messageType, data) =>
			@components.forEach ( component ) ->
				component.receive messageType, data

		update: (delta, totalTime) =>
			@components.forEach (component) ->
				#console.log component
				component.update(delta, totalTime, @)

		destroy: =>
			@components.forEach (component) ->
				component.destroy()


	class Renderable extends GameObject


	class Moveable extends Renderable
		constructor: ->
			super
			@velocity = new THREE.Vector3()


	class Player extends Moveable
		constructor: ->
			super
			@components.push new PlayerInputComponent()
			@components.push new SocketComponent()



	###
	Pluggable Components
	###
	COMPONENT_MESSAGE_TYPES = {
		PLAYER_INPUT : 0
		SOCKET_MESSAGE : 1
	}

	class GameComponent

		update : ( delta, totalTime, gameObject ) =>

		destroy : () =>

		receive : (messageType, messageData) =>

	
	MOVEMENT_DIRECTIONS = {
		FORWARD : new THREE.Vector3(0,0,1.0)
		BACKWARD : new THREE.Vector3(0,0,-1.0)
		LEFT : new THREE.Vector3( -1.0,0,0 )
		RIGHT : new THREE.Vector3( 1.0,0,0 )
	}
	


	class InputComponent extends GameComponent

		update : (delta, totalTime, gameObject) =>

	class PlayerInputComponent extends InputComponent

		constructor: ->
			super
			@keyspressed = []
			@setupListeners()

		setupListeners : =>
			document.addEventListener 'keydown', @onKeyDown
			document.addEventListener 'keyup', @onKeyUp

		onKeyDown : (event) =>
			if not event.keyCode in @keyspressed
				@keyspressed.push event.keyCode

		onKeyUp : (event) =>
			@keyspressed = @keyspressed.filter (keycode) -> keycode isnt event.keyCode

		update : ( delta, totalTime, gameObject ) =>
			gameObject.send( COMPONENT_MESSAGE_TYPES.PLAYER_INPUT, @keyspressed )
			#console.log @keyspressed

		destroy : =>
			document.removeEventListener 'keydown', @onKeyDown
			document.removeEventListener 'keyup', @onKeyUp

	class SocketComponent extends GameComponent


	{
		GameObject : GameObject
		GameComponent : GameComponent
		InputComponent : InputComponent
		PlayerInputComponent : PlayerInputComponent
		Player : Player
		SocketComponent : SocketComponent
	}






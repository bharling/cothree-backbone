define ['jquery', 'underscore', 'backbone','three'], ( $, _, Backbone, THREE ) ->

	###
	GameObject 'container'
	###
	class GameObject
		constructor: ->
			@components = []
			@position = new THREE.Vector3()
			@bounds = new THREE.Box3

		send : (message) =>
			@components.forEach ( component ) ->
				component.receive ( message )

		update: (delta, totalTime) =>
			@components.forEach (component) ->
				component.update(delta, totalTime, @)

		destroy: =>
			@components.forEach (component) ->
				component.destroy()


	class Player extends GameObject
		constructor: ->
			super()
			@components.push new PlayerInputComponent(@)



	###
	Pluggable Components
	###

	class ComponentMessage
		constructor: ( @messageType, @data ) ->


	class GameComponent
		constructor : (data) ->
			_.extend @, data

		update : ( delta, totalTime, gameObject ) =>

		destroy : () =>

	class InputComponent extends GameComponent
		constructor: (@target) ->
			super({})

		update : (delta, totalTime, gameObject) =>

	class PlayerInputComponent extends InputComponent

		constructor: (@target) ->
			super(@target)
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
			#console.log @keyspressed

		destroy : =>
			document.removeEventListener 'keydown', @onKeyDown
			document.removeEventListener 'keyup', @onKeyUp

	class SocketComponent extends GameComponent



	{
		GameObject : GameObject,
		GameComponent : GameComponent,
		ComponentMessage : ComponentMessage,
		InputComponent : InputComponent,
		PlayerInputComponent : PlayerInputComponent,
		Player : Player,
		SocketComponent : SocketComponent
	}






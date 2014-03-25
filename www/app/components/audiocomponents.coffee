define ['!cs../util/utils.coffee'], (utils) ->

	class Audio extends utils.Singleton
		constructor: ->
			@buffer = new utils.RingBuffer()

		playSound: (sound) =>
			@buffer.push sound

		update: (delta, totalTime) =>
			sound = @buffer.get
			if sound
				@_playSound(sound)

		_playSound: ( sound ) =>

	{
		Audio: Audio
	}
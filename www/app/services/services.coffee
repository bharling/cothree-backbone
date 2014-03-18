define ['jquery', 'underscore', 'bootstrap', 'three', 'cs!../util/utils'], ($,_,Bootstrap, THREE, utils) ->

	# Service locator pattern from:
	# http://gameprogrammingpatterns.com/service-locator.html


	# Public interface to audio service provider
	class Audio
		playSound : (soundId) =>

		stopSound : (soundId) =>

		stopAllSounds : =>

	# Null audio service acting as a placeholder
	class NullAudioService extends Audio
		playSound : (soundId) =>
			console.log("null audio play")

	# Concrete implementation
	class AudioService extends Audio
		playSound : (soundId) =>
			# Actually play sound here

		stopSound : (soundId) =>
			# Actually stop sound here

		stopAllSounds : =>
			# Actually mute everything here 


	# Static Service Locator 
	class ServiceLocator
		@_audioService = null
		
		@initialize: ->
			ServiceLocator._audioService = new NullAudioService 

		@getAudio : ->
			return ServiceLocator._audioService

		@provideAudio : (service) ->
			if service?
				ServiceLocator._audioService = service

	{
		NullAudioService : NullAudioService
		AudioService : AudioService
		ServiceLocator : ServiceLocator
	}
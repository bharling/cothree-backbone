define [
	'jquery',
	'underscore',
	'backbone'
], ( $, _, Backbone ) ->
	root = exports ? this

	class Item extends Backbone.Model

		defaults:
			part1 : 'Hello'
			part2 : 'Backbone'

	class List extends Backbone.Collection

		model : Item

	class ItemView extends Backbone.View
		tagName: 'li'

		render: ->
			$(@el).html "<span>#{@model.get 'part1'} #{@model.get 'part2'}</span>"
			@


	class ListView extends Backbone.View
		el: $ '#app'

		initialize: ->
			#_.bindAll @, 'onClick'


			@collection = new List
			@collection.bind 'add', @appendItem

			@counter = 0
			@render()

		render: -> 
			console.log @
			$(@el).append '<button>Add Item</button>'
			$(@el).append '<ul><ul>'
			@

		addItem: ->
			@counter++
			item = new Item()
			item.set part2: "#{item.get 'part2'} #{@counter}"
			@collection.add item

		appendItem: (item) ->
			item_view = new ItemView model:item
			$('ul').append item_view.render().el

		events: 'click button' : 'addItem'

	root.ListView = ListView
	root




	

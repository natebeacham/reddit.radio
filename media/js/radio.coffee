class Radio extends Backbone.View
	events:
		'click #next': 'next',
		'click #prev': 'prev',
		'change #sub-selector': 'load',

	initialize: ->
		@setElement $('body')[0]
		@delegateEvents()
		@load()

	load: ->
		sub = $('#sub-selector').val()
		@getJSON sub

	getJSON: (sub) ->
		$.getJSON 'http://www.reddit.com' + sub + '/.json?jsonp=?', (response) =>
			@loadResult response.data.children

	loadResult: (items) ->
		@items = (item.data for item in items when item.data.url.indexOf 'youtub' != -1)
		console.log @items
		@current = 0
		@play()

	play: ->
		$('#player').empty()
		console.log @items[@current]
		$('h1').html(@items[@current].title)
		$('#status').html('Playing ' + (@current + 1) + ' of ' + @items.length)

		id = @getID @items[@current].url

		if id
			$('#player').append '''
				<iframe width="100%" id="yt" height="100%" src="//www.youtube.com/embed/''' + id + '''?autoplay=1&enablejsapi=1" frameborder="0"
				allowfullscreen></iframe>
			'''

	getID: (url) ->
		regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
		match = url.match regExp

		if match and match[2].length == 11
			return match[2]

	next: ->
		if @current + 1 <= @items.length
			@current++
			@play()

	prev: ->
		if @current - 1 >= 0
			@current--
			@play()

$ ->
	new Radio
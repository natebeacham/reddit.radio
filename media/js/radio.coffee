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
		@block()
		sub = $('#sub-selector').val()
		@getJSON sub

	getJSON: (sub) ->
		$.getJSON 'http://www.reddit.com' + sub + '/.json?limit=100&jsonp=?', (response) =>
			@loadResult response.data.children

	loadResult: (items) ->
		@items = (item.data for item in items when item.data.url.indexOf('youtub') != -1)
		@current = 0
		@play()

	block: ->
		$('#shade').fadeIn()

	unblock: ->
		$('#shade').fadeOut()

	play: ->
		data = @items[@current]

		$('#player').empty().append '<div id="video"></div>'

		$('#story').html("<a href='http://reddit.com#{data.permalink}' target='_blank'>#{data.title}</a>")

		$('#status').html('Playing ' + (@current + 1) + ' of ' + @items.length)

		id = @getID @items[@current].url

		if id
			@player = new YT.Player 'video',
				height: '100%',
				width: '100%',
				videoId: id,
				events:
					onStateChange: _.bind(@stateChange, this),
					onReady: (e) =>
						e.target.playVideo()
						@unblock()

	getID: (url) ->
		try
			url.match(/(?:https?:\/{2})?(?:w{3}\.)?youtu(?:be)?\.(?:com|be)(?:\/watch\?v=|\/)([^\s&]+)/)[1]
		catch e
			console.log url

	next: (e) ->
		if e
			e.preventDefault()

		if @current + 1 <= @items.length
			@current++
			@play()

	prev: (e) ->
		if e
			e.preventDefault()

		if @current - 1 >= 0
			@current--
			@play()

	stateChange: (data) ->
		if data.data == 0
			@next()

$ ->
	new Radio

export state = ->
	hydrated: false

export mutations =
	set: (state, navigation) ->
		Object.assign state, navigation
		state.hydrated = true

export actions =

	# Get navigation data fresh from SSG or fresh depending on the app env
	fetch: ({ commit }) ->
		console.log 'bro'

export state = ->
	hydrated: false

export mutations =
	set: (state, navigation) ->
		Object.assign state, navigation
		state.hydrated = true

export actions =
	fetch: ({ commit }) ->
		console.log 'fetch'

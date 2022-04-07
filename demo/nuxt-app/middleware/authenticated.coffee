###
Require authentication
###
export default ({ app, store, redirect }) ->

	# Wait for customer to be hydrated
	unless store.state.customer.hydrated
	then await new Promise (resolve) ->
		unwatch = store.watch(
			(state) -> state.customer.hydrated
			(hydrated) -> if hydrated then unwatch() && resolve()
		)

	# If not logged in, redirect to home page
	unless store.getters['customer/isAuthenticated']
	then redirect '/account/login'

###
Require NO-authentication
###
export default ({ app, store, redirect }) ->

	# Wait for customer to be hydrated
	unless store.state.customer.hydrated
	then await new Promise (resolve) ->
		unwatch = store.watch(
			(state) -> state.customer.hydrated
			(hydrated) -> if hydrated then unwatch() && resolve()
		)

	# If logged in, redirect to account page
	if store.getters['customer/isAuthenticated']
	then redirect '/account'

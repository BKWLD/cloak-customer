###
Require authentication
###
export default ({ app, store, redirect }) ->

	# Wait for customer to be hydrated
	await new Promise (resolve) ->
		unwatch = store.watch ((state) -> state.customer.hydrated)
		, ((hydrated) -> unwatch() && resolve() if hydrated)
		, immediate: true

	unless store.getters['customer/isAuthenticated']
	then redirect '/account/login'

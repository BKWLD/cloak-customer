###
Require NO-authentication
###
export default ({ app, store, redirect }) ->

	# Wait for customer to be hydrated
	await new Promise (resolve) ->
		store.watch ((state) -> state.customer.hydrated)
		, ((hydrated) -> resolve() if hydrated)
		, immediate: true

	if store.getters['customer/isAuthenticated']
	then redirect '/account'

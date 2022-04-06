###
Require authentication
###
export default ({ app, store, redirect }) ->

	console.log 'in authenticated'

	# Wait for customer to be hydrated
	await new Promise (resolve) ->
		store.watch ((state) -> state.customer.hydrated)
		, ((hydrated) -> resolve() if hydrated)
		, immediate: true

	# if the customer is NOT authenticated, then route back to home
	unless store.getters['customer/isAuthenticated']
	then redirect '/'

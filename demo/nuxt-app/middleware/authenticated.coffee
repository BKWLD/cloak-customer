###
Require authentication
###
export default ({ app, store, redirect }) ->

	console.log 'in authenticated'

	# Wait for customer to be hydrated
	# await new Promise (resolve) ->
	# 	unwatch = store.watch ((state) -> state.customer.hydrated)
	# 	, ((hydrated) -> unwatch() && resolve() if hydrated)
	# 	, immediate: true

	# unless store.getters['customer/isAuthenticated']
	# then redirect '/gate'

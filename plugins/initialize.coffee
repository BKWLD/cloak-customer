# Load use package path because relative paths require the nuxt module
# to register them with addPlugin
import * as customerStore from '@cloak-app/customer/store/customer'
export default ({ store, redirect }, inject) ->

	# Register the vuex module
	store.registerModule 'customer', {
		namespaced: true
		...customerStore
	}

	# Immediately try to login the customer
	store.dispatch 'customer/loginFromStorage'

	# Invoke callback when customer is hydrated
	whenCustomerHydrated = -> new Promise (resolve) ->
		if store.state.customer.hydrated then resolve()
		else unwatch = store.watch(
			({ customer }) -> customer.hydrated
			(hydrated) ->
				return unless hydrated
				unwatch()
				resolve()
		)

	# Middleware helper for pages that require an un-authentincated user, like
	# the login page
	inject 'unauthenticated', ->
		await whenCustomerHydrated()
		if store.getters['customer/isAuthenticated']
		then redirect '/account'

	# Middleware helper forpages that require an authenticated user, like on the
	# main account page
	inject 'authenticated', ->
		await whenCustomerHydrated()
		unless store.getters['customer/isAuthenticated']
		then redirect '/account/login'

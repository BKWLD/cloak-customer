# Load use package path because relative paths require the nuxt module
# to register them with addPlugin
import * as customerStore from '@cloak-app/customer/store/customer'
export default ({ store }) ->

	# Register the vuex module
	store.registerModule 'customer', {
		namespaced: true
		...customerStore
	}

	# Immediately try to login the customer
	store.dispatch 'customer/loginFromStorage'



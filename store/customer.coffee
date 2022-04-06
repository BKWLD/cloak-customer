import * as customerApi from '../services/shopify/customer'
import { cookie } from '../helpers/helpers'

customerIdKey = 'customerId'

export state = ->

	# Customer info
	id: null
	email: null
	firstName: null
	lastName: null
	defaultAddress: null
	tags: null

	# Shopify auth data
	accessToken: null
	expiresAt: null

	# Have we determined whether they are authenticated or not? This can be true
	# but still have no accessToken.
	hydrated: false

	addresses: []

export getters =

	# Helper for checking if user is authenticated
	isAuthenticated: (state) -> !!state.accessToken

export mutations =

	# Replace customer and auth data
	setAuth: (state, auth) -> Object.assign state, auth
	setCustomer: (state, customer) -> Object.assign state, customer

	# Null out all state
	clear: (state) ->
		for key, val of state
			if typeof val == 'boolean'
			then state[key] = false
			else state[key] = null

	# Set hydrated state
	isHydrated: (state) -> state.hydrated = true

	setCustomerAddresses: (state, addresses) -> state.addresses = addresses

export actions =

	# Create a customer then log them in
	create: ({ commit, dispatch }, { email, password, firstName, lastName }) ->
		customer = await customerApi.create { email, password, firstName, lastName }
		await dispatch 'login', { email, password }

	# add a tag to the customer
	addTag: ({}, { tag, id }) ->
		await customerApi.addTag { tag, id }

	# trigger a password reset email
	recoverPassword: ({}, { email }) ->
		await customerApi.recoverPassword { email }

	# reset a password
	resetPassword: ({}, { payload }) ->
		await customerApi.resetPassword { payload }

	# Activate a new customer
	activateAccount: ({}, { payload }) ->
		await customerApi.activateAccount { payload }

	# Login a customer
	login: ({ commit, dispatch }, { email, password }) ->
		auth = await customerApi.login { email, password }
		await dispatch 'handleAuth', auth

	# Login a customer from cookie state.  If it fails, silently ignore (they
	# won't be logged in) though this _does_ count as being hydrated.
	loginFromStorage: ({ commit, dispatch }) ->

		# Check for access token on cookie
		unless accessToken = cookie.get customerIdKey
		then return commit 'isHydrated'

		# Try to renew the token, which will fail if it's a bad token
		try auth = await customerApi.renew { accessToken }
		catch e
			cookie.remove customerIdKey
			return commit 'isHydrated'

		# Finish hydrating the customer
		await dispatch 'handleAuth', auth

	# DRY up code that handles the customerAccessToken from Shopify
	handleAuth: ({ commit, dispatch }, { accessToken, expiresAt } ) ->

		# Store auth values
		commit 'setAuth', { accessToken, expiresAt }

		# Persist across sessions
		cookie.set customerIdKey, accessToken, expires: new Date expiresAt

		# Finish hydrating customer
		await dispatch 'fetch'

	# Get customer data using accessToken from state
	fetch: ({ commit, state: { accessToken } }) ->
		customer = await customerApi.fetch { accessToken }
		commit 'setCustomer', customer
		commit 'isHydrated'

	# Logout a customer
	logout: ({ commit, state: { accessToken } }) ->

		await customerApi.logout { accessToken } if accessToken
		commit 'clear'
		cookie.remove customerIdKey

	# set the customer addresses on the store
	fetchAddresses: ({ commit, state: { accessToken } }) ->
		addresses = await customerApi.getAddresses { accessToken }
		commit 'setCustomerAddresses', addresses

	# Create an address
	createAddress: ({ dispatch, state: { accessToken } }, { address }) ->
		address = await customerApi.createAddress { address, accessToken }
		await dispatch 'fetchAddresses'

	# Edit an address
	updateAddress: ({ dispatch, state: { accessToken } }, { id, address }) ->
		await customerApi.updateAddress { id, address, accessToken }
		await dispatch 'fetchAddresses'

	# Delete an address
	deleteAddress: ({ dispatch, state: { accessToken } }, { id }) ->
		await customerApi.deleteAddress { id, accessToken }
		await dispatch 'fetchAddresses'

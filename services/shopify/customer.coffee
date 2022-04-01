# ###
# Helpers for interacting with customer APIs
# ###
import createQuery from '../../queries/create.gql'
import renewQuery from '../../queries/renew.gql'
import loginQuery from '../../queries/login.gql'
import fetchQuery from '../../queries/fetch.gql'
import recoverQuery from '../../queries/recover.gql'
import resetPasswordQuery from '../../queries/reset-password.gql'
import activateQuery from '../../queries/activate.gql'
import logoutQuery from '../../queries/logout.gql'
import addressesQuery from '../../queries/addresses.gql'
import addressCreateQuery from '../../queries/address-create.gql'
import addressUpdateQuery from '../../queries/address-update.gql'
import addressDeleteQuery from '../../queries/address-delete.gql'
import ordersQuery from '../../queries/orders.gql'
import { execute, findEdgeNodes } from './storefront'

# Standardize error handling
executeCustomerMutation = (queryPayload) ->

	# Try the request and map any errors to the expected type for mutations
	try { mutation: response } = await execute queryPayload
	catch e then throw new CustomerMutationError [
		field: null
		code: null
		message: 'Communication error'
	]

	# If userErrors were found, throw an excpetion with their messages
	if response.userErrors?.length
	then throw new CustomerMutationError response.userErrors

	# Return successful data
	return response.data

# Throw exception that supports an array of error messages
class CustomerMutationError extends Error
	name: 'CustomerMutationError'
	constructor: (errors, payload) ->
		messages = errors.map ({ message }) -> message
		super messages.join ', '
		@errors = errors
		@messages = messages

# Register a new customer
export create = ({ email, password, firstName, lastName }) ->
	executeCustomerMutation
		query: createQuery
		variables: input: { email, password, firstName, lastName }

# Trigger a password reset
export recoverPassword = ({ email }) ->
	executeCustomerMutation
		query: recoverQuery
		variables: email: email

# Reset the password
export resetPassword = ({ payload }) ->
	id = payload.id
	input = payload.input
	executeCustomerMutation
		query: resetPasswordQuery
		variables: { input, id }

# Activate an account
export activateAccount = ({ payload }) ->
	id = payload.id
	input = payload.input
	executeCustomerMutation
		query: activateQuery
		variables: { input, id }

# Get the access token
export login = ({ email, password }) ->
	executeCustomerMutation
		query: loginQuery
		variables: input: { email, password }

# Validate and refresh the access token expiration
export renew = ({ accessToken }) ->
	executeCustomerMutation
		query: renewQuery
		variables: { accessToken }

# Get a customer given their access token
export fetch = ({ accessToken }) ->
	response = await execute
		query: fetchQuery
		variables: { accessToken }
	return response.customer

# Delete a user's session
export logout = ({ accessToken }) ->
	execute
		query: logoutQuery
		variables: { accessToken }

# Get a customer's addresses
export getAddresses = ({ accessToken, perPage = 12, afterCursor }) ->
	response = await execute
		query: addressesQuery
		variables: { accessToken, perPage, afterCursor }
	response.customer.addresses

# Get a customer's orders
export getOrders = ({ accessToken, perPage = 12, afterCursor }) ->
	response = await execute
		query: ordersQuery
		variables: { accessToken, perPage, afterCursor }
	response.customer.orders

# Create an address
export createAddress = ({ address, accessToken }) ->
	await execute
		query: addressCreateQuery
		variables: { accessToken, address }

# Update an address
export updateAddress = ({ id, address, accessToken }) ->
	await execute
		query: addressUpdateQuery
		variables: { accessToken, address, id }

# Delete an address
export deleteAddress = ({ id, accessToken }) ->
	await execute
		query: addressDeleteQuery
		variables: { accessToken, id }

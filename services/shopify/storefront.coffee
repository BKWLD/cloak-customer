###
Build a client for querying the Shopify Storefront API
###
import axios from 'axios'
import mapValues from 'lodash/mapValues'
import isPlainObject from 'lodash/isPlainObject'

# Error object with custom handling
class StorefrontError extends Error
	name: 'StorefrontError'
	constructor: (errors, payload) ->
		super errors.map((e) -> e.debugMessage || e.message).join ', '
		@errors = errors.map (e) -> JSON.stringify e
		@payload = payload

# Run an API query
export execute = (payload) ->
	console.log process.env.SHOPIFY_URL, process.env.SHOPIFY_STOREFRONT_TOKEN
	response = await axios
		url: "#{process.env.SHOPIFY_URL}/api/2022-01/graphql"
		method: 'post'
		headers:
			'Accept': 'application/json'
			'Content-Type': 'application/json'
			'X-Shopify-Storefront-Access-Token': process.env.SHOPIFY_STOREFRONT_TOKEN

		# Should have query and maybe variables properties
		data: payload

	# Handle errors in response
	if response.data.errors
		throw new StorefrontError response.data.errors, payload

	# Return data
	return flattenEdges response.data.data

# Recurse through an object and flatten eddge/node levels
flattenEdges = (obj) ->

	# If an array, act on all members
	if Array.isArray obj then return obj.map flattenEdges

	# If not an object, return self
	return obj unless isPlainObject obj

	# Loop through object properties
	mapValues obj, (val, key) ->

		# If there is an "edges" child, flatten it's contents
		if val?.edges
		then val = val.edges.map ({ node }) -> node

		# Recurse deeper
		flattenEdges val

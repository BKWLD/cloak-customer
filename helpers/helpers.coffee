import Vue from 'vue'
import Cookies from 'js-cookie'

export wait = (ms, cb) -> setTimeout cb, ms

# Mount a component within an element
export mountComponent = (
	component,    # A Vue component object or reference
	options = {}, # Component intialization options
	{             # Mounting options
		el,         # Mount inside of this element, defaults to document.body
		prepend,    # Boolean, prepend instad of append
	} = {}
) -> new Promise (resolve) ->

	# Set default options
	el = document.body unless el
	options.parent = window.$nuxt?.$root unless options.parent

	# Mounts the component
	mount = ->
		vm = new (Vue.extend component)(options)
		vm.$mount()
		el[if prepend then 'prepend' else 'appendChild'](vm.$el)
		resolve vm

	# Wait until Nuxt is booted to mount
	if window.$nuxt then mount() else wait 50, mount


# Format a string or number like money
export formatMoney = (val) -> '$' + twoDecimals val

# Add two decimal places
export twoDecimals = (val) ->
	locale = navigator?.language || 'en-US'
	parseFloat(val).toLocaleString locale,
		minimumFractionDigits: 2
		maximumFractionDigits: 2

# Format money for a product, which may be free
export productCost = (val) ->
	if parseFloat(val) == 0
	then 'Free'
	else formatMoney val


# Get the current apex (root) domain
export currentApexDomain = ->
	location.hostname.match(/(?:^|\.)((?:[^.]+\.)?[^.]+)$/)[1]



# Helpers for interacting with cookies that get shared across domains
export cookie = new class SharedCookie

	# Make the env-specifc key suffic
	constructor: ->
		@suffix = if (env = process.env.APP_ENV) == 'prod'
		then '' else "-#{env}"

	# Set a cookie that can be shared across subdomains
	set: (key, value, options = {}) ->
		Cookies.set key + @suffix, value, {

			# Don't try to share between domains when on a deploy preview
			domain: do ->
				if (apexDomain = currentApexDomain()) == 'netlify.app'
				then undefined else apexDomain

			# Don't expect SSL locally
			secure: location.hostname not in ['localhost']

			# Don't send to any 3rd party sites
			sameSite: 'strict'

			# Allow overriding
			...options
		}

	# Get a cookie
	get: (key) -> Cookies.get key + @suffix

	# Remove a cookie
	remove: (key) -> Cookies.remove key + @suffix, domain: currentApexDomain()


export formatPhone = (phoneNumberString) ->
	cleaned = ('' + phoneNumberString).replace(/\D/g, '')
	match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/)
	if match
		return '(' + match[1] + ') ' + match[2] + '-' + match[3]

# Get the id from a Shoify gid:// style id.  This strips everything but the
# last part of the string.  So
# gid://shopify/MailingAddress/34641879105581?accessToken=....
# becomes 34641879105581
export getShopifyId = (base64id) ->
	atob(base64id).match(/^gid:\/\/shopify\/\w+\/(\w+)/)?[1]

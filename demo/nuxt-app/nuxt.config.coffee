# Use Cloak to make boilerplate
{ mergeConfig, makeBoilerplate, isDev, isGenerating } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
	siteName: 'demo'
	cms: '@nuxt/content'
	srcsetWidths: [ 1920, 1440, 1024, 768, 425, 210 ]

# Nuxt config
module.exports = mergeConfig boilerplate,

	env:
		APP_ENV: process.env.APP_ENV || process.env.SENTRY_ENVIRONMENT || 'dev'
		SHOPIFY_STOREFRONT_TOKEN: process.env.SHOPIFY_STOREFRONT_TOKEN
		SHOPIFY_URL: process.env.SHOPIFY_URL
		NUXT_APP_URL: process.env.URL


	modules: [
		'@nuxt/content'
		'vue-unorphan/nuxt/module'
		'vue-balance-text/nuxt/module'
	]

	plugins: [
		{ src: 'plugins/country-region-select' }
	]

	build:

		# Always show ouput
		quiet: false

		# Useful to disable when debugging polyfill issues
		# optimization: minimize: false

		# External code that needs transpiling
		transpile: [
			'library' # The workspace
		]

		# ExtractCSS
		extractCSS: true unless isDev

		# PostCSS configuration
		postcss: plugins:

			# Disable CSS Nano's Calc transfrom, it beefs with my fluid() function
			cssnano: do ->
				if isDev then false
				else preset: ['default', calc: false ]



	buildModules: [
		'@cloak-app/customer/nuxt'
	]

	# Expect specially slug-ed towers to exist that will be loaded by error.vue
	generate: fallback: true

	# Customize the routes
	router: extendRoutes: (routes) ->

		# Support customer and token route segments an activate and reset. So they
		# become like /account/reset/:customerId/:resetToken
		for route in routes
			if match = route.path.match /^\/account\/(activate|reset)/
			then route.path = "#{match[0]}/:customerId/:token"

	# Disable SSR on account pages
	serverMiddleware: [ '~/middleware/client-only-pages' ]

	# Add production internal URL
	anchorParser: internalUrls: [
		# /^https?:\/\/(www\.)?domain\.com/
	]


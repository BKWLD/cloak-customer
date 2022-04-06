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

	buildModules: [
		'@cloak-app/customer/nuxt'
	]

	# Expect specially slug-ed towers to exist that will be loaded by error.vue
	generate: fallback: true

	# Add production internal URL
	anchorParser: internalUrls: [
		# /^https?:\/\/(www\.)?domain\.com/
	]


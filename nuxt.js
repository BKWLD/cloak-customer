import { join } from 'path'
import { sortRoutes } from '@nuxt/utils'
import { requireOnce } from '@cloak-app/utils'
import defaultsDeep from 'lodash/defaultsDeep'
import { setPublicDefaultOptions } from '@cloak-app/utils'
export default function() {

	// Have Nuxt transpile resources
	this.options.build.transpile.push('@cloak-app/customer')

	// Expose .env config
	defaultsDeep(this.options.env, {
		APP_ENV: process.env.APP_ENV,
		SHOPIFY_URL: process.env.SHOPIFY_URL,
		SHOPIFY_STOREFRONT_TOKEN: process.env.SHOPIFY_STOREFRONT_TOKEN,
	})

	// Don't SSR account pages
	this.addServerMiddleware(join(__dirname, './middleware/client-only-pages.js'))

	// Allow components to be auto-imported by Nuxt
	this.nuxt.hook('components:dirs', dirs => {
		dirs.push({
			path: join(__dirname, './components'),
			extensions: ['vue', 'js', 'coffee'],
			prefix: 'cloak-customer',
			level: 2,
		})
	})

	// Set default options
	setPublicDefaultOptions(this, 'customer', {
		authenticatedRoute: '/account',
		unauthenticatedRoute: '/account/login'
	})

	// Add the plugin that boots up all the runtime code
	this.options.plugins.push({
		src: join(__dirname, './plugins/initialize.coffee'),
	});

	// Register package page routes
	this.extendRoutes((routes, resolve) => {

		// Support customer and token route segments an activate and reset. So they
		// become like /account/reset/:customerId/:resetToken
		routes.forEach((route) => {
			if(route.path.match(/^\/account\/(activate|reset)/)) {
				route.path = "#{match[0]}/:customerId/:token";
			}
		})

		// Define all the customer page routes
		const customerRoutes = [
			{
				name: 'customer-login',
				path: '/account/login',
				component: 'pages/login.vue'
			},
			{
				name: 'customer-logout',
				path: '/account/logout',
				component: 'pages/logout.vue'
			},
			{
				name: 'customer-register',
				path: '/account/register',
				component: 'pages/register.vue'
			},
			{
				name: 'customer-account',
				path: '/account',
				component: 'pages/index.vue'
			},
			{
				name: 'customer-reset',
				path: '/account/reset',
				component: 'pages/reset.vue'
			},
		]

		// Hand over page routes to Nuxt
		customerRoutes.forEach(({ name, path, component }) => routes.push({
			name,
			path,
			component: resolve(__dirname, component),
			chunkName: name,
		}))

		// Apply Nuxt sorting of routes
		sortRoutes(routes)
	})

	// Configure style-resources module to append package definitions
	defaultsDeep(this.options, { styleResources: { stylus: [] }})
	this.options.styleResources.stylus
		.push(join(__dirname, 'styles/definitions.styl'))

	// Add style-resources module late so other modules can append imports
	this.nuxt.hook('modules:done', moduleContainer => {
		requireOnce(moduleContainer, '@nuxtjs/style-resources')
	})
}

// Required for published modules
module.exports.meta = require('./package.json')

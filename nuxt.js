import { join } from 'path'
import { sortRoutes } from '@nuxt/utils'
export default function() {

	// Have Nuxt transpile resources
	this.options.build.transpile.push('@cloak-app/customer')

	// this.addServerMiddleware('')


	this.nuxt.hook('build:start', builder => {
		// transpile all coffeescript here?
	})

	// Allow components to be auto-imported by Nuxt
	this.nuxt.hook('components:dirs', dirs => {

		// components
		dirs.push({
			path: join(__dirname, './components'),
			extensions: ['vue', 'js', 'coffee'],
			prefix: 'cloak-customer',
			level: 2,
		})

	})

	this.addPlugin({
		src: join(__dirname, './plugins/initialize.coffee'),
	});


	// Relay package options to runtime config
	// this.options.publicRuntimeConfig.cloak = {
	// 	...this.options.publicRuntimeConfig.cloak,
	// 	customer: {
	// 		...this.options.cloak?.customer,
	// 	}
	// }


	// Add module depdencies
	// this.requireModule('vue-routing-anchor-parser/nuxt/module')

	// TODO: these were coming from the project's nuxt config
	// Disable SSR on account pages
	// this.serverMiddleware = [ './middleware/client-only-pages' ]
	// plugins.push({ src: 'plugins/hydrate-customer', mode: 'client' });

	// Register package page routes
  this.extendRoutes((routes, resolve) => {

		// routes
		let customRoutes = [
			{ name: 'customer-login', path: '/account/login', component: 'components/pages/login.vue' },
			{ name: 'customer-logout', path: '/account/logout', component: 'components/pages/logout.vue' },
			{ name: 'customer-register', path: '/account/register', component: 'components/pages/register.vue' },
			{ name: 'customer-account', path: '/account', component: 'components/pages/index.vue' },
			{ name: 'customer-reset', path: '/account/reset', component: 'components/pages/reset.vue' }
		]

		customRoutes.forEach((route) => {
			routes.push({
				name: route.name,
				path: route.path,
				component: resolve(__dirname, route.component),
				chunkName: route.name
			})
		})

    sortRoutes(routes)

			// TODO: Should this be here or in extendRoutes in the project itself
		// Support customer and token route segments an activate and reset. So they
		// become like /account/reset/:customerId/:resetToken
		routes.forEach((route) => {
			if(route.path.match(/^\/account\/(activate|reset)/)) {
				route.path = "#{match[0]}/:customerId/:token";
			}
		})


  })

}

// Required for published modules
module.exports.meta = require('./package.json')

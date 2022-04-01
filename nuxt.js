import { join } from 'path'
import { sortRoutes } from '@nuxt/utils'
export default function() {

	// Have Nuxt transpile resources
	this.options.build.transpile.push('@cloak-app/customer')

	this.addServerMiddleware(join(__dirname, './middleware/client-only-pages.js'))

	// Tried this, they worked when I put them in the product
	// here it was trying to load coffee and erroring
	// this.addServerMiddleware(join(__dirname, './middleware/authenticated.coffee'))
	// this.addServerMiddleware(join(__dirname, './middleware/unauthenticated.coffee'))

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

	// Register package page routes
  this.extendRoutes((routes, resolve) => {

		// Support customer and token route segments an activate and reset. So they
		// become like /account/reset/:customerId/:resetToken
		routes.forEach((route) => {
			if(route.path.match(/^\/account\/(activate|reset)/)) {
				route.path = "#{match[0]}/:customerId/:token";
			}
		})

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

  })

}

// Required for published modules
module.exports.meta = require('./package.json')

import { join } from 'path'
import { sortRoutes } from '@nuxt/utils'
export default function() {

	// Have Nuxt transpile resources
	this.options.build.transpile.push('@cloak-app/customer')

	// this.addServerMiddleware(join(__dirname, './middleware/client-only-pages.js'))

	// Allow components to be auto-imported by Nuxt
	this.nuxt.hook('components:dirs', dirs => {

		console.log('in dir');

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


		let customRoutes = [
			{ name: 'customer-login', path: '/account/login', component: 'pages/login.vue' },
			{ name: 'customer-logout', path: '/account/logout', component: 'pages/logout.vue' },
			{ name: 'customer-register', path: '/account/register', component: 'pages/register.vue' },
			{ name: 'customer-account', path: '/account', component: 'pages/index.vue' },
			{ name: 'customer-reset', path: '/account/reset', component: 'pages/reset.vue' }
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

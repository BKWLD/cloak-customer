// Nuxt config
export default {

	// Load boilerplate and this package's module
	buildModules: [
		'@cloak-app/boilerplate/nuxt',
		'@cloak-app/demo-theme/nuxt',
		'../nuxt',
	],

	// Cloak settings
	cloak: {

		// Boilerplate settings
		boilerplate: {
			siteName: '@cloak-app/customer demo',
		},

	},

	// @nuxt/content can't be loaded from module
	modules: ['@nuxt/content'],
}
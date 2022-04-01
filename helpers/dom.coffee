###
Helpers related to manipulating the DOM
###
import Vue from 'vue'

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

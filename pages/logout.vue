<!-- Delete user state on an empty page before redirecting to fix
     issues with variables being undefined before the redirect -->

<script lang='coffee'>
export default

	middleware: ({ app }) -> await app.$authenticated()

	layout: ({ $config }) -> $config.cloak.customer.layout

	# Execute code on mount, once old page has been destroyed
	mounted: ->
		await @$store.dispatch 'customer/logout'

		# TODO: Better way to do this?
		window.location.reload()

	# Render an empty page
	render: (create) ->

</script>

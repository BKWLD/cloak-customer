<!-- Delete user state on an empty page before redirecting to fix
     issues with variables being undefined before the redirect -->

<script lang='coffee'>
export default

	middleware: ({ app }) -> await app.$authenticated()

	# Execute code on mount, once old page has been destroyed
	mounted: ->
		await @$store.dispatch 'customer/logout'
		console.log 'logged out, go home'
		@$router.push '/'

	# Render an empty page
	render: (create) ->

</script>

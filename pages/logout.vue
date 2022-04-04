<!-- Delete user state on an empty page before redirecting to fix
     issues with variables being undefined before the redirect -->

<script lang='coffee'>
export default

	middleware: 'authenticated'

	# Execute code on mount, once old page has been destroyed
	mounted: ->
		await @$store.dispatch 'customer/logout'
		@$router.push '/'

	# Render an empty page
	render: (create) ->

</script>

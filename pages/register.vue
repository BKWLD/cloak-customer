<!-- Customer Registration -->
<template lang='pug'>

.cloak-customer

	cloak-customer-forms-register(can-login)

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	middleware: ({ app }) -> await app.$unauthenticated()

	mounted: ->
		if @$store.state.customer.email
			@$router.push '/account'


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

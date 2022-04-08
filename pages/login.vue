<template lang='pug'>

.cloak-customer

	//- need v-show cause of the ref for submission in the recovery form
	cloak-customer-forms-login(v-show='!recover' can-register v-on:toggle='toggleForm')
	cloak-customer-forms-recover(v-show='recover' v-on:toggle='toggleForm')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	middleware: ({ app }) -> await app.$unauthenticated()

	layout: ({ $config }) -> $config.cloak.customer.layout

	data: ->
		recover: false

	mounted: ->
		if @$store.state.customer?.email
			@$router.push '/account'

	methods:
		toggleForm: -> @recover = !@recover

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

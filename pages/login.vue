<template lang='pug'>

.cloak-customer

	//- need v-show cause of the ref for submission in the recovery form
	form-login(v-show='!recover' can-register v-on:toggle='toggleForm')
	form-recover(v-show='recover' v-on:toggle='toggleForm')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import FormLogin from '../components/forms/login'
import FormRecover from '../components/forms/recover'

export default

	middleware: 'unauthenticated'

	components: { FormLogin, FormRecover}

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

// @import '../../styles/customer-shared.styl'

</style>

<!-- Customer Registration -->
<template lang='pug'>

.cloak-customer

	form-register(can-login)

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import FormRegister from '../components/forms/register'

export default

	components: { FormRegister }

	middleware: 'unauthenticated'

	mounted: ->
		if @$store.state.customer.email
			@$router.push '/account'


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

<!-- Customer Registration -->
<template lang='pug'>

.cloak-customer: .form-wrap

	h1 Register for a new account

	form-register

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import FormRegister from '../forms/register'

export default

	components: { FormRegister }

	middleware: 'unauthenticated'

	mounted: ->
		if @$store.state.customer.email
			@$router.push '/account'


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-form.styl'

</style>

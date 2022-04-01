<template lang='pug'>

.account-links

	smart-link.icon.icon-account-logged-in(
		to='/account'
		v-if='email'
		aria-label='account')

	smart-link.icon.icon-account(
		to='/account/login'
		v-else
		aria-label='account')

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default
	computed:
		customer: -> @$store.state.customer
		email: -> @customer?.email

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>

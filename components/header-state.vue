<template lang='pug'>

.account-links
	smart-link(to='/account' v-if='customer') My Account
	smart-link(to='/account/login' v-else) Login


</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	data: ->
		loaded: false

	computed:
		customer: -> @$store.state.customer?.email


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

</style>

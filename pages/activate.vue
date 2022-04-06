<template lang='pug'>

.cloak-customer
	cloak-customer-forms-activate

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	middleware: 'unauthenticated'


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

<!-- Customer Registration -->
<template lang='pug'>

.cloak-customer

	cloak-customer-forms-register(can-login)

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	middleware: ({ app }) -> await app.$unauthenticated()

	layout: ({ $config }) -> $config.cloak.customer.layout

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

<template lang='pug'>

.cloak-customer

	cloak-customer-forms-reset

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	layout: ({ $config }) -> $config.cloak.customer.layout

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

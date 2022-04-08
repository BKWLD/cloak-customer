<template lang='pug'>

.cloak-customer.account.max-w

	//- hold modal, so it's within this
	div(ref='modalContainer')

	//- sidebar on desktop
	//- full dropdown on mobile
	cloak-customer-account-navigation

	.main-column

		//- orders
		.dashboard-segment#orders

			.headline
				h2.style-h2 Orders

			//- If orders, show them
			div.orders(v-if='orders.length > 0')
				cloak-customer-account-order-card(
					v-for='order in orders'
					:key='order.id'
					:order='order')

			div(v-else)
				p No Orders


		//- addresses
		.dashboard-segment#addresses

			.headline
				h2.style-h2 Addresses
				btn(@click='addNewAddress') New Address


			//- If addresses, shopw them
			.addresses(v-if='addresses.length > 0')
				cloak-customer-account-address-card(
					v-for='address in addresses' :key='address.id'
					:is-default='isDefault(address)'
					:address='address')

			//- NO Addresses
			div(v-else)
				p No Addresses

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import AddressModal from '../components/modals/address'
import * as customerApi from '../services/shopify/customer'
import { mountComponent } from '../helpers/helpers'

import Vue from 'vue'
import vueCountryRegionSelect from 'vue-country-region-select'
Vue.use(vueCountryRegionSelect)


export default

	components: {
		AddressModal
	}

	middleware: ({ app }) -> await app.$authenticated()

	# Fetch orders and addresses from Shopify
	asyncData: ({ app, store }) ->
		{ accessToken } = store.state.customer

		await store.dispatch 'customer/fetchAddresses'

		orders = await customerApi.getOrders { accessToken }
		return { orders }

	computed:

		customer: -> @$store.state.customer
		defaultAddressId: -> @customer?.defaultAddress?.id
		addresses: -> @$store.state.customer?.addresses || []

	methods:

		addNewAddress: ->
			await mountComponent AddressModal,
				parent: this
				propsData:
					address: {}

		# Check if address is the primary address. The ids can't be compared
		# directly because the ids contain accessToken values in them that change
		# the resultant base64ed value on each instance.
		isDefault: (address) ->
			@$getShopifyId(address.id) == @$getShopifyId(@defaultAddressId)

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../styles/customer-shared.styl'

</style>

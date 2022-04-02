<template lang='pug'>

.cloak-customer.account.max-w

	//- sidebar on desktop
	//- full dropdown on mobile
	customer-navigation

	.main-column

		//- orders
		.dashboard-segment#orders

			.headline
				h2.style-h2 Orders

			//- If orders, show them
			div.orders(v-if='orders.length > 0')
				order-card(
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
				address-card(
					v-for='address in addresses' :key='address.id'
					:is-default='isDefault(address)'
					:address='address')

			//- NO Addresses
			div(v-else)
				p No Addresses

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import OrderCard from '../account/order-card'
import AddressCard from '../account/address-card'
import AddressModal from '../modals/address'
import CustomerNavigation from '../account/navigation'
import * as customerApi from '../../services/shopify/customer'
import { mountComponent } from '../../helpers/helpers'

export default

	components: {
		OrderCard
		AddressCard
		AddressModal
		CustomerNavigation
	}

	middleware: 'authenticated'

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

@import '../../styles/customer-shared.styl'

</style>

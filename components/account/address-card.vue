<template lang='pug'>

.customer-card(:class='classes' :aria-label='addressLabel')

	.top
		.company(v-if='address.company') {{ address.company }}
		.name {{ address.name }}

	div {{ address.address1 }}
	div {{ address.address2 }}

	div
		span {{ address.city }} &nbsp;
		span {{ address.province }}, &nbsp;
		span {{ address.country }} &nbsp;
		span {{ address.zip }}

	.phone(v-if='phone') {{ phone }}

	.actions
		.inline-cta(@click='updateAddress') Edit
		.inline-cta(@click='deleteAddress') Delete

	div(v-if='isDefault')
		.pill.default: span Primary/Default

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import AddressModal from '../modals/address'
import { mountComponent, formatPhone } from '../../helpers/helpers'
import atob from 'atob-lite'

export default

	components: { AddressModal }

	props:
		address: Object # The address to be rendered
		isDefault: Boolean # Is this the default address

	data: ->
		loading: false

	computed:
		url: -> "/account/addresses/#{@address.id}"
		classes: -> [
			'disabled' if @loading
		]

		phone: -> formatPhone @address.phone

		addressLabel: ->
			if @isDefault then return 'Default Address'
			else return 'Customer Address'

	methods:
		deleteAddress: ->
			id = @address.id

			# click to proceed
			check = window.confirm 'Delete Address'
			if !check then return

			@loading = true
			try
				await @$store.dispatch 'customer/deleteAddress', { id }
			catch e then @errors = e.messages || ['Unknown error']
			finally @loading = false

		updateAddress: ->
			await mountComponent AddressModal,
				parent: this
				propsData:
					address: @address

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-card.styl'

.customer-card
	transition opacity base-speed ease-out

	&.disabled
		pointer-events none
		opacity .4

.pill
	margin-top spacing-xxs

.name, .company
	display inline-block
	margin-v 2px

.top
	display flex
	align-items center
	flex-wrap wrap

.phone
	margin-top 10px !important

.company
	margin-right spacing-xxs
	padding-v 5px
	padding-h spacing-xxs
	background ui-grey
	border-radius cloak-customer-radius
	fluid-font 'bold', 16, 14

</style>

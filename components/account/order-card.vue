<template lang='pug'>

smart-link.customer-card.order(@click='openOrderModal' :aria-label='label')

	.row
		.name {{ order.name }}
		.date {{ order.processedAt | date }}
	.price {{ price }}
	.actions
		.inline-cta View More

	.pill(:class='order.fulfillmentStatus | lowercase')
		span {{ order.fulfillmentStatus }}

	.warning(v-if='order.canceledAt') Cancelled on {{ order.canceledAt | date }}

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import OrderModal from '../modals/order'
import { mountComponent, formatMoney } from '../../helpers/helpers'

export default

	components: { OrderModal }

	props:
		order: Object

	filters:
		date: (val) -> new Date(val).toLocaleDateString 'en-US'
		lowercase: (val) -> val.toLowerCase()

	computed:
		price: -> formatMoney @order.totalPrice.amount
		label: -> "Order #{@order.name}"

	methods:
		openOrderModal: ->
			await mountComponent OrderModal,
				parent: this
				propsData:
					order: @order


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-card.styl'

.order
	cursor pointer

.name
	font-family monospace
	font-weight bold

.date
	fluid-font 'bold', 13, 13, grey

.price
	style-h4()
	color primary-color

.row
	display flex
	align-items center
	margin-bottom spacing-xxs

	.name
		flex-grow 1

</style>

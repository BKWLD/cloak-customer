<template lang='pug'>

modal(:closeable='true' type='standard' v-on:close='closed')
	.customer-modal.order-details

		.headline
			h3.style-h3 Order {{ order.name }}
			.order-date
				span Order placed on
				span {{ order.processedAt | date }}

		hr

		div.warning(v-if='order.canceledAt') Cancelled on {{ order.canceledAt | date }}

		//- Order Status
		.half
			h4.style-h4 Fulfillment
			.pill.default {{ order.financialStatus }}

		//- Order Fulfillment
		.half
			h4.style-h4 Status
			.pill(:class='order.fulfillmentStatus | lowercase ') {{ order.fulfillmentStatus }}

		hr

		div(v-if='hasTracking')

			h4.style-h4 TRACKING
			.company {{ order.tracking[0].company }}
			.number(v-if='order.tracking[0].info[0]')
				a.pill.tracking(:href='order.tracking[0].info[0].url' target='blank') {{ order.tracking[0].info[0].number }}

			hr

		//- line items
		h4.style-h4 Items In Order

		.line-items
			line-item-card(v-for='item, index in order.lineItems'
				:key='index' :item='item')

		.totals
			.line Subtotal: {{ subtotal }}
			.line Tax: {{ tax }}
			.line Shipping: {{ shipping }}
			.line.total Total: {{ total }}


</template>

<script lang='coffee'>
import LineItemCard from '../account/line-item-card'
import Modal from '@bkwld/vue-modal'
import '@bkwld/vue-modal/index.css'
import { formatMoney } from '../../helpers/helpers'

export default

	components: { LineItemCard, Modal }

	filters:
		date: (val) -> new Date(val).toLocaleDateString 'en-US'
		money: (val) -> "$#{val}"
		lowercase: (val) -> val.toLowerCase()

	props:
		order: Object

	computed:
		subtotal: -> formatMoney @order.subtotalPrice.amount
		total: -> formatMoney @order.totalPrice.amount
		tax: -> formatMoney @order.totalTaxPrice.amount
		shipping: -> formatMoney @order.totalShippingPrice.amount
		hasTracking: -> @order.tracking?[0]?.company?

	methods:
		closed: -> @$el.remove()

</script>

<style lang='stylus' scoped>
@import '../../styles/customer-shared.styl'
@import '../../styles/customer-modal.styl'

// .line-items
// 	margin-v spacing-s

// .order-date

// 	@media(min-width:400px)
// 		text-align right

// 	span
// 		display block
// 		margin-v 3px
// 		fluid-font 'bold', 14, 14, grey

// .totals
// 	text-align right

// .line
// 	margin-top spacing-xxs
// 	fluid-font 'body', 16, 14

// 	&.total
// 		fluid-font 'bold', 16, 14

// .company
// 	margin-top 5px
// 	fluid-font 'bold', 16, 14

</style>

<template lang='pug'>

.customer-card(:aria-label='label')
	.title.style-h4 {{ title }}
	.variant(v-if='variant') {{ variantTitle }} - ({{ sku }})

	.qty-and-price

		.price {{ price }}

		div(v-if='discounts')
			span Discount: {{ item.discountAllocations[0].allocatedAmount.amount }}

		.qty Qty: {{ qty }}

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import { productCost } from '../../helpers/helpers'

export default

	props:
		item: Object

	computed:
		title: -> @item?.title
		variant: -> @item?.variant
		variantTitle: -> @item?.variant?.title
		sku: -> @item?.variant?.sku
		qty: -> @item?.quantity
		discounts: -> @item?.discountAllocations?.length > 0
		price: -> productCost @item.originalTotalPrice.amount
		label: -> "Order Line Item #{@title}"

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-card.styl'

.qty-and-price
	display flex
	justify-content space-between
	padding-top 10px

.price
	fluid-font 'bold', 18, 16, green

.qty
	fluid-font 'bold', 18, 16, grey

.variant
	fluid-font 'bold', 15, 15, grey

</style>

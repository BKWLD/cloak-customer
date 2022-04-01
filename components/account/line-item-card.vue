<template lang='pug'>

.customer-card(:aria-label='label')
	.title.style-h5 {{ title }}
	.variant(v-if='variant') {{ variantTitle }} - ({{ sku }})

	.qty-and-price

		.price {{ price }}

		div(v-if='discounts')
			span Discount: {{ item.discountAllocations[0].allocatedAmount.amount }}

		.qty Qty: {{ qty }}

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

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
		price: -> @$productCost @item.originalTotalPrice.amount
		label: -> "Order Line Item #{@title}"

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-card.styl'

.qty-and-price
	display flex
	justify-content space-between

.price
	fluid-font 'bold', 18, 16, green

.qty
	fluid-font 'bold', 18, 16, grey

</style>

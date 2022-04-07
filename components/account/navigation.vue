<template lang='pug'>

.customer-navigation

	.customer-information
		span.name {{ customer.firstName }} {{ customer.lastName }}
		span.email {{ customer.email }}

	.mobile-navigation.hide-desktop(:class='mobileNavClasses')
		accessibility-btn(
			v-on:click='toggleNav'
			label='Toggle Account Navigation')
			.nav-toggle(aria-hidden='true')
				span Account Navigation
				.icon-caret

		.hide-desktop
			transition(name='fade')
				account-navigation-links(v-show='mobileNavOpen')

	account-navigation-links.hide-mobile


</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
import AccessibilityBtn from '../accessibility-btn'
import AccountNavigationLinks from './navigation-links'

export default

	components: { AccountNavigationLinks, AccessibilityBtn }

	data: ->
		loaded: false
		mobileNavOpen: false

	computed:
		customer: -> @$store.state.customer
		mobileNavClasses: -> [
			'nav-open' if @mobileNavOpen
		]

	methods:
		toggleNav: ->
			if !@mobileNavOpen then @mobileNavOpen = true
			else @mobileNavOpen = false

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'

.customer-information
	line-height 1.2
	word-wrap break-word

+tablet-up()
	.customer-navigation
		width 250px
		padding spacing-xs
		border-radius radius

	.name
		display block
		fluid-font 'bold', 16, 14
		margin-bottom spacing-xxs

	.email
		display block
		fluid-font 'body', 16, 14
		font-style italic

	ul
		border 1px solid ui-grey
		margin-top spacing-xs
		border-radius radius

		li
			&:not(:first-child)
				border-top 1px solid ui-grey

+tablet-down()
	.customer-information
		margin-v spacing-s

	.nav-toggle
		background #f0f0f0
		display flex
		align-items center
		padding spacing-s
		cursor pointer

		span
			flex-grow 1

	.name
		display block
		fluid-font 'bold', 16, 14
		margin-bottom spacing-xxs

	.email
		display block
		fluid-font 'body', 16, 14
		font-style italic

	.mobile-navigation
		margin-bottom spacing-s
		&.nav-open
			.icon-caret
				transform rotate(180deg)

</style>

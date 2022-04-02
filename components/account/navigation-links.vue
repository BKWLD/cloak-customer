<template lang='pug'>

div

	ul(aria-label='Account Navigation')

		li
			smart-link(to='/account') Account
		li
			smart-link(to='/account#orders') Orders
		li
			smart-link(to='/account#addresses') Addresses
		//- li
		//- 	smart-link(:to='subscriptionsUrl') Subscriptions
		li
			span(@click='recoverPassword') Reset Password
		li
			smart-link(to='/account/logout') Logout

	.success(v-if='success.length' role='alert')
		div(v-for='item, index in success' :key='index') {{ item }}


</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	data: ->
		customer: @$store.state.customer
		success: []

	# Hydrate the cart so we can get the cart id for the subscriptionsUrl
	# mounted: -> @$store.dispatch 'cart/fetchUnlessHydrated'

	computed:
		email: -> @$store.state.customer.email

		# Route to subscriptions management through auth redirector
		subscriptionsUrl: ->
			redirector = '/.netlify/functions/auth-redirect'
			subscriptionsUrl = "#{process.env.SHOPIFY_URL}/tools/recurring/login"
			"#{redirector}?" + new URLSearchParams
				url: subscriptionsUrl
				cartId: @$store.state.cart.id

	methods:

		# Trigger a password recovery email using your email address
		recoverPassword: ->
			@loading = true
			try login = await @$store.dispatch 'customer/recoverPassword', { @email }
			catch e then @errors = e.messages || ['Unknown error']
			finally
				@loading = false
				@success.push 'An email has been sent with password reset instructions'

				@$wait 3000, =>
					@success = []


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'

.success
	margin-top 10px

ul
	border 1px solid ui-grey
	margin-top spacing-s
	border-radius radius

	li
		&:not(:first-child)
			border-top 1px solid ui-grey

	span
		cursor pointer

	a, span
		display block
		padding spacing-s
		transition all base-speed ease-out
		cursor pointer
		fluid-font 'bold', 16, 14

		&:hover
			background primary-color
			color white

</style>

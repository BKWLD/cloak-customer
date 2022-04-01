<template lang='pug'>

.cloak-customer

	.max-w-xsmall.customer-form-wrap

		h1 Activate your account

		form(@submit.prevent='formSubmit')

			//- error messages if applicable
			.errors(v-if='errors.length' role='alert')
				div(v-for='error, index in errors' :key='index') {{ error }}

			//- success message with prompt to login
			.success(v-if='success')
				h4.style-h4 Successfully Activated
				btn: smart-link(to='/account') Login Now

			div(v-else)

				label(for='password')
					span New Password
					input(
						name='password'
						placeholder='New Password'
						type='password'
						required
						v-model='form.password')

				.form-actions
					btn(:loading='loading' type='submit') Set New Password

					ul
						li
							smart-link(to='/account/login') Return to login

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	middleware: 'unauthenticated'

	data: ->
		loading: false
		success: false
		errors: []
		form: password: ''

	computed:

		# Make the submit payload
		payload: ->
			id: @$makeShopifyId 'Customer', @$route.params.customerId
			input:
				password: @form.password
				activationToken: @$route.params.token

	methods:

		formSubmit: (e) ->
			@loading = true

			try
				await @$store.dispatch 'customer/activateAccount', { @payload }
				@success = true
			catch e then @errors = e.messages || ['Unknown error']
			finally @loading = false


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-form.styl'

</style>

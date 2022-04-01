<template lang='pug'>

form(@submit.prevent='onSubmit')

	//- error messages if applicable
	.errors(v-if='errors.length' role='alert')
		div(v-for='error, index in errors' :key='index') {{ error }}

	//- success message w/ prompt to login
	.success(v-if='success')
		h3.style-h3 Successfully Reset Password
		btn(to='/account/login') Login Now

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


	data: ->
		processing: false
		success: false
		errors: []
		form: password: ''

	computed:

		# Make the submit payload
		payload: ->
			id: @$makeShopifyId 'Customer', @$route.params.customerId
			input:
				password: @form.password
				resetToken: @$route.params.token

	methods:

		onSubmit: (e) ->
			@processing = true
			try
				await @$store.dispatch 'customer/resetPassword', { @payload }
				@success = true
			catch e then @errors = e.messages || ['Unknown error']
			finally @processing = false

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-form.styl'

</style>

<template lang='pug'>

//- The password recovery form
//- Don't make this a form element, so chrome doesn't try to
//- autocomplete the field
form(@submit.prevent='onSubmit' v-else)

	//- error messages if applicable
	.errors(v-if='errors.length' role='alert')
		div(v-for='error, index in errors' :key='index') {{ error }}

	//- success message
	.success(v-if='success.length' role='alert')
		div(v-for='item, index in success' :key='index') {{ item }}

	p Submit your email to recover your password

	label(for='email')
		span Email Address
		input(
			name='email'
			type='email'
			ref='recoveryEmail'
			placeholder='Email Address'
			autocomplete)

	.form-actions
		btn(:loading='processing' type='submit') Send Reset Link

		ul
			li
				span.link(@click='toggle') Click here to login


</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	data: ->
		processing: false
		errors: []
		success: []

	methods:

		# trigger an email to recover your password
		onSubmit: (e) ->
			@processing = true

			# reset messages
			@errors = []
			@success = []

			# define data
			email = @$refs.recoveryEmail.$el.querySelector('input').value

			# do the recover action
			try
				await @$store.dispatch 'customer/recoverPassword', { email }
				@success.push 'An email has been sent with password reset instructions'
			catch e then @errors = e.messages || ['Unknown error']
			finally @processing = false

		toggle: ->
			@$emit 'toggle'


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-form.styl'

</style>

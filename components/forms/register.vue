<!-- Customer Registration -->
<template lang='pug'>

form.cloak-customer-form(@submit.prevent='onSubmit' ref='form')

	h2.style-h2 Account Registration

	//- error messages if applicable
	.errors(v-if='errors.length' role='alert')
		div(v-for='error, index in errors' :key='index') {{ error }}

	label(for='firstName')
		span First Name
		input(
			type='text'
			name='firstName'
			placeholder='First Name'
			minlength='3'
			maxlength='100')

	label(for='lastName')
		span Last Name
		input(
			type='text'
			name='lastName'
			placeholder='Last Name'
			minlength='3'
			maxlength='100')

	label(for='email')
		span Email Address
		input(
			type='email'
			name='email'
			placeholder='Email Address'
			autocomplete
			required)

	label(for='password')
		span Password
		input(
			type='password'
			name='password'
			placeholder='Password'
			minlength='3'
			required
			autocomplete)


	.form-actions
		btn(:loading='processing' type='submit') Register

		ul
			li(v-if='canLogin')
				span Already have an account?
				smart-link(to='/account/login') Login

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	props:
		canLogin:
			type: Boolean
			default: false

	data: ->
		processing: false
		errors: []

	methods:

		# Form submit, and register a new customer
		onSubmit: (e) ->
			@processing = true

			# reset errors on submit
			@errors = []

			# prep the data
			form = @$refs.form
			firstName = form.elements['firstName'].value
			lastName = form.elements['lastName'].value
			email = form.elements['email'].value
			password = form.elements['password'].value
			tags = ['pending']

			if password.length < 5
				@errors.push 'Password is too short, please make sure it\'s at least 5 characters'
				return

			# Attempt to submit
			try
				await @$store.dispatch 'customer/create', { email, password, firstName, lastName, tags }
				@$router.push '/account'
			catch e then @errors = e.messages || ['Unknown error']
			finally @processing = false



</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-form.styl'

</style>

<template lang='pug'>

form(@submit.prevent='onSumbit' ref='form')

	//- error messages if applicable
	.errors(v-if='errors.length' role='alert')
		div(v-for='error, index in errors' :key='index') {{ error }}

	label(for='email')
		span Email Address
		input(
			type='text'
			name='email'
			placeholder='Email Address'
			required
			autocomplete)

	label(for='password')
		span Password
		input(
			type='password'
			name='password'
			placeholder='Password'
			minlength='5'
			required
			autocomplete)


	.form-actions

		btn(:loading='processing' type='submit') Login

		ul
			li(v-if='canRegister')
				span Don't have an account?
				smart-link(to='/account/register') Register Now
			li
				span.link(@click='toggle') Click here to reset your password


</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	props:
		canRegister:
			type: Boolean
			default: false

	data: ->
		processing: false
		errors: []
		success: []

	methods:

		# the login form submission
		onSumbit: (e) ->
			@processing = true

			# reset messages
			@errors = []
			@success = []

			# define data
			form = @$refs.form
			email = form.elements['email'].value
			password = form.elements['password'].value

			# do the logging action
			# set loading to false regardless of success or failure
			try
				login = await @$store.dispatch 'customer/login', { email, password }
				@$router.push '/account'
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

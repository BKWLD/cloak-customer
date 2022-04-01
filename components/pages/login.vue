<template lang='pug'>

.cloak-customer

	.max-w-xsmall.customer-form-wrap

		h1 Login to your account

		form(@submit.prevent='loginFormSubmit' ref='form' v-if='!recover')

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

				btn(:loading='loading' type='submit') Login

				ul
					li
						span Don't have an account?
						smart-link(to='/account/register') Register Now
					li
						span.link(@click='toggleForm') Click here to reset your password


		//- The password recovery form
		//- Don't make this a form element, so chrome doesn't try to
		//- autocomplete the field
		form(@submit.prevent='recoverFormSubmit' v-else)

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
				btn(:loading='loading' type='submit' @click='recoverFormSubmit') Send Reset Link

				ul
					li
						span.link(@click='toggleForm') Click here to login


</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	middleware: 'unauthenticated'

	data: ->
		loading: false
		recover: false
		errors: []
		success: []

	mounted: ->
		if @$store.state.customer?.email
			@$router.push '/account'

	computed:
		title: -> if @recover then 'Recover Password' else 'Customer Login'

	methods:

		toggleForm: -> @recover = !@recover

		# the login form submission
		loginFormSubmit: (e) ->
			@loading = true

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
			finally @loading = false

		# trigger an email to recover your password
		recoverFormSubmit: (e) ->
			@loading = true

			# reset messages
			@errors = []
			@success = []

			# define data
			email = @$refs.recoveryEmail.$el.querySelector('input').value

			# do the recover action
			# set loading to false regardless of success or failure
			try
				login = await @$store.dispatch 'customer/recoverPassword', { email }
				@success.push 'An email has been sent with password reset instructions'
			catch e then @errors = e.messages || ['Unknown error']
			finally @loading = false


</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-form.styl'

</style>

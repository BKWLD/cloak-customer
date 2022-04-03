<template lang='pug'>

modal.cloak-address-modal(
	:closeable='true'
	type='standard'
	ref='modal'
	removeOnClose)

		h2.style-h3(v-if='address.address1') Edit Address
		h2.style-h3(v-else) New Address

		.errors(v-if='errors.length' role='alert')
			div(v-for='error, index in errors' :key='index') {{ error }}

		form(@submit='processAddress' ref='form')

			.half-wrap
				label(for='firstName')
					span First Name
					input(
						type='text'
						name='firstName'
						placeholder='First Name'
						v-model='currentAddress.firstName'
						required
						maxlength='100')

				label(for='lastName')
					span Last Name
					input(
						type='text'
						name='lastName'
						placeholder='Last Name'
						v-model='currentAddress.lastName'
						required
						maxlength='100')

			label(for='company')
				span Company (optional)
				input(
					type='text'
					name='company'
					placeholder='Company (optional)'
					v-model='currentAddress.company'
					maxlength='100')

			label(for='address1')
				span Address Line 1
				input(
					type='text'
					name='address1'
					placeholder='Address Line 1'
					v-model='currentAddress.address1'
					required
					maxlength='100')

			label(for='address2')
				span Address Line 2 (optional)
				input(
					type='text'
					name='address2'
					placeholder='Address Line 2 (optional)'
					v-model='currentAddress.address2'
					maxlength='100')

			label(for='city')
				span City
				input(
					type='text'
					name='city'
					placeholder='City'
					v-model='currentAddress.city'
					maxlength='100')

			.dropdown-container
				.icon-caret
				country-select(v-model='currentAddress.country' :country='currentAddress.country' topCountry='US')

			.dropdown-container
				.icon-caret
				region-select(v-model='currentAddress.province' :country='currentAddress.country' :region='currentAddress.province')

			.half-wrap
				label(for='zip')
					span Zip Code
					input(
						type='text'
						name='zip'
						placeholder='Zip Code'
						v-model='currentAddress.zip'
						required
						maxlength='50')

				label(for='phone')
					span Phone Number (optional)
					input(
						type='number'
						name='phone'
						placeholder='Phone Number (optional)'
						v-model='currentAddress.phone'
						maxlength='20')

			.bottom-actions
				.btn(type='submit') {{ btnText }}


</template>

<script lang='coffee'>
import Modal from '@bkwld/vue-modal'
import '@bkwld/vue-modal/index.css'
import AccessibilityBtn from '../accessibility-btn'

import Vue from 'vue'
import vueCountryRegionSelect from 'vue-country-region-select'
Vue.use(vueCountryRegionSelect)

import { clearAllBodyScrollLocks } from 'body-scroll-lock'


export default

	components: { AccessibilityBtn, Modal }

	props:
		address: Object

	data: ->
		errors: []
		loading: false
		edit: false

		currentAddress: {
			firstName: ''
			lastName: ''
			company: ''
			address1: ''
			address2: ''
			city: ''
			country: ''
			province: ''
			zip: ''
			phone: ''
		}

	fetch: ->
		if @address.address1

			addr = {
				address1: @address.address1
				address2: @address.address2
				country: ''
				province: ''
				city:  @address.city
				zip:  @address.zip
				phone:  @address.phone
				firstName: @address.firstName
				lastName: @address.lastName
				company: @address.company
			}

			@currentAddress = addr
			@edit = true

	computed:
		countryClasses: -> [
			'disabled' if @countries.length <= 1
		]

		provinceClasses: -> [
			'disabled' if @provinces.length <= 1
		]

		currentPhone: -> @currentAddress?.phone?.length > 0

		btnText: -> if @edit then 'Edit Address' else 'Add New Address'

	methods:

		# either edit, or create a new address
		processAddress: (e) ->

			e.preventDefault()

			@errors = []

			# first check for province, province, and country
			if !@currentAddress.country && !@currentAddress.province
				@errors.push 'please select a country and state/province'
				return

			endpoint = if @edit then 'customer/updateAddress'  else 'customer/createAddress'

			payload = {
				address: @currentAddress
			}

			# if editing, pass the address ID
			if @edit then payload.id = @address.id

			# # massage the phone number
			if @currentPhone

				phone = @currentAddress.phone.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '')
				if phone.length < 10
					@errors.push 'please enter correct phone number (with area code)'
					return
				else
					@currentAddress.phone = phone

			@loading = true
			try
				addresses = await @$store.dispatch endpoint, payload
				@closeModal() # close the modal if successful
			catch e then @errors = e.messages || ['Unknown error']
			finally @loading = false

		closeModal: ->
			@$refs.modal.close()


</script>

<style lang='stylus' scoped>

@import '../../styles/customer-shared.styl'
@import '../../styles/customer-modal.styl'

>>>
	.bvm-contents
		text-align left
		padding spacing-m

	.bvm-slot
		border-radius 10px

	.bvm-close
		color primary-color
		top 20px
		right 20px

.dropdown-container
	position relative
	display inline-block
	width 100%
	padding 10px
	margin-v spacing-s
	border 1px solid primary-color
	min-height 44px

	.icon-caret
		position absolute
		font-size 10px
		top 50%
		right spacing-s
		transform translateY(-40%)

	>>> select
		border none
		appearance none
		expand()
		cursor pointer
		text-overflow ellipsis
		padding-left spacing-s

	.visual-label
		label-style()
		fluid top, -32, -26
		opacity 1

	>>> select:required:invalid
		color blue


</style>

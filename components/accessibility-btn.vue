<template lang='pug'>

.accessibility-btn(
	role='button'
	tabindex='0'
	:aria-label='label'
	@click='onClick')

	//- the element to be clicked on
	slot

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>

export default

	props:
		label: String
		expandable: Boolean

	data: ->
		expanded: false

	mounted: ->
		@$el.addEventListener 'keydown', @onKeyDown
		if @expandable then @$el.setAttribute('aria-expanded', 'false')

	destroyed: ->
		@$el.removeEventListener 'keydown', @onKeyDown

	methods:

		onClick: (e) ->
			if @expandable then @toggleAriaExpanded()
			@$emit('click')

		onKeyDown: (e) ->
			keyD = if e.key != undefined then e.key else e.keyCode
			if keyD == 'Enter' or keyD == 13 or ['Spacebar', ' '].indexOf(keyD) >= 0 or keyD == 32
				e.preventDefault()
				@$emit('click')

		toggleAriaExpanded: ->
			if !@expanded
				@expanded = true
				@$el.setAttribute('aria-expanded', 'true')
			else
				@expanded = false
				@$el.setAttribute('aria-expanded', 'false')

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>

.accessibility-btn
	cursor pointer

</style>

# @cloak-app/customer

Cloak components for rendering Customer components.  [View demo](https://cloak-customer.netlify.app/).

## Install

1. Install with `yarn add @cloak-app/customer`
2. Add to `nuxt.config` with `buildModules: ['@cloak-app/customer/nuxt']`
3. Make sure components is set to true in the project's nuxt.config so the components can be auto-loaded
4. Set Shopify admin api permissions
- create a private 'develop' app
- allow admin api access & allow permission to
- write_customers
- read_customers
5. Make sure accounts are at least set to optional on the shop (/admin/settings/checkout)
6. Add country-region-select to plugins in the project
- Create a `nuxt-app/plugins` folder
- add `vue-country-region-select.coffee` with the following:
```
import Vue from 'vue'
import vueCountryRegionSelect from 'vue-country-region-select'
Vue.use(vueCountryRegionSelect)
```

### Options

- `cloak.customer:`
  - `authenticatedRoute` - The route to redirect users who aren't authenticated. Defaults to `/account`
  - `unauthenticatedRoute` - The route to redirect users who aren't authenticated. Defaults to `/account/login`

### Project Dependencies

- `@nuxt/utils`
- `@bkwld/vue-modal` #9dc40c6
- `vue-country-region-select`


### Expected styles
- spacing (xs - xxl)
- ui-grey
- primary-color
- ui-error
- on-desktop() and on-mobile() breakpoint helpers

### Expected ENV vars
- SHOPIFY_URL
- APP_ENV
- SHOPIFY_STOREFRONT_TOKEN

### Module Options

<!-- - `cloak.copy:`
  - `maxWidthClass` - The max width class to use to `max-w-medium` -->

## Components

<!-- ### `cloak-copy`

This is a generic copy renderer that can be used by other Cloak components so they can stay ignorant of the CMS.  For instance, a FAQ component with a CMS-specific adapater.  In this case, the FAQ component can just pass along the `content` content it was provided to `cloak-copy` and never know whether it is rendering markup from Redactor or rich text from Contentful.

- props:
  - `content` - Either an HTML string or a Contentful rich text JSON document
  - `balanceText` - Boolean, enables [vue-balance-text](https://github.com/BKWLD/vue-balance-text)
  - `unorphan` - Boolean, enables [vue-unorphan](https://github.com/BKWLD/vue-unorphan)
 -->

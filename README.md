# @cloak-app/customer

Cloak components for rendering Customer components.  [View demo](https://cloak-customer.netlify.app/).

```vue

```

## Install

1. Install with `yarn add @cloak-app/customer`
2. Add to `nuxt.config` with `buildModules: ['@cloak-app/customer/nuxt']`
3. Add middleware to nuxt-config
```
# Disable SSR on account pages
serverMiddleware: [ '@cloak-app/customer/middleware' ]
```
4. Set Shopify admin api permissions
- create a private 'develop' app
- allow admin api access & allow permission to
- write_customers
- read_customers
5. Make sure accounts are at least set to optional on the shop (/admin/settings/checkout)

### Project Dependencies

- `@nuxt/utils`
- `@bkwld/vue-modal` #9dc40c6
- `vue-country-region-select`


### Expected styles
- spacing (xs - xxl)
- ui-grey
- primary-color
- on-desktop() and on-mobile() breakpoint helpers

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

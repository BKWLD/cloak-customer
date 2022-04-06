
/**
 * This makes account pages (which depend on client side data) to not be SSRed
 * when running dev mode.  Based on:
 * https://blog.lichter.io/posts/nuxt-dynamic-ssr-spa-handling/
 */
export default function (req, res, next) {
	if (req.url.match(/^\/account/)) {
		res.spa = true
	}
	next()
}

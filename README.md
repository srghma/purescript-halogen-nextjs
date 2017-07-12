# purescript-halogen-nextjs

A server side rendering framework for purescript-halogen, like next.js is a framework for react,
written fully in purescript.

It is using not yet published features/packages:
- https://github.com/purescript-halogen/purescript-halogen-vdom/pull/38
- https://github.com/purescript-halogen/purescript-halogen/pull/671
- https://github.com/srghma/webpack-spago-loader

### Features:

1. js and css is split per page using webpack machinery
1. when `Nextjs.Lib.Link.component` appears in the viewport - the page dependencies are prefetched
1. on initial rendering the `Nextjs.Lib.Page.DynamicPageData` is fetched on server side and result in
inserted into the page into the `<script id="__PAGE_DATA__">JSON<script>`

### How it works

1. How to run it?

```
yarn dev
```

or

```
yarn build && yarn serve
```

1. Where pages are stored?

Page is a top level purescript file in the `app/pages` directory (e.g. `app/pages/Foo.purs`)

Page should export the `page :: Page` object (which is a `PageSpec` object, but with existentially hidden `input` type
argument)

1. What is a meaning of `.deps.js` files?

If there is a file in the `app/pages/` directory ending with `.deps.js` (e.g. `app/pages/Foo.deps.js`) - it will be
required before the page is loaded

(Check [createClientPagesEntrypoints.js](https://github.com/srghma/purescript-halogen-nextjs/blob/master/webpack/config/createClientPagesEntrypoints.js#L71)
and [isomorphic-client-pages-loader](https://github.com/srghma/purescript-halogen-nextjs/blob/master/webpack/lib/isomorphic-client-pages-loader.js#L30-L33)
to see how it works)

You can use `app/pages/Foo.deps.js` to add per page css files (it's just for splitting css, the css is global, i.e.
the `<link rel="stylesheet" ...>` element is not removed after you go to the some other page)

Or You can use it for adding per page js dependencies (like ace npm package, that will be loaded only for `Ace.purs` page)

1. Where can I define global css and js?

In the `client.entry.css` and `client.entry.js`


### TODO:

1. PWA with service worker https://pursuit.purescript.org/packages/purescript-workers/
2. An example with cookies authentication and secure page
3. Move reusable parts into the separate package, publish to pursuit and npm
4. Finish https://github.com/srghma/generate-halogen-css-modules to generate FFI for css files ending with `.module.css`

The [css modules](https://webpack.js.org/loaders/css-loader/#modules) are enabled only for files ending with `.module.css` [here](https://github.com/srghma/purescript-halogen-nextjs/blob/master/webpack/config/rules.js#L20)

5. https://www.npmjs.com/package/livereload and custom https://www.npmjs.com/package/webpack-livereload-plugin for dev

![example](https://i.imgur.com/VF5UY5s.png)

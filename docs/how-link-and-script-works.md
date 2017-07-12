# link "preload" vs "prefetch"

- preload - warming the cache for current sessions
- prefetch - load when idle

# script "async" vs "defer"

from
- https://github.com/jantimon/html-webpack-plugin/issues/113#issuecomment-206964112
- https://flaviocopes.com/javascript-async-defer/

summary
- without anything at the `<head>` - DOM building is blocked until `<script>` is evaluated, `<script>` cannot see anything below
- without anything at the end of `<body>` - `<script>` cannot see anything below, but is loaded only after whole html is parsed
- "defer" - load in parallel, execute after DOM is built, doesnt block parsing, but before `DOMContentLoaded` event, order is saved
- "async" - load in parallel, execute when loaded (before or after DOM is built), blocks parsing, `<script>`'s are executed in parallel without order, `DOMContentLoaded` is not dependent on "async" script (i.e. can happen before or after)

what we want:
- we want to start loading scripts as early as possible ("preload" in head)
- we want to start executing scripts as late as possible ("script" in end of body)
- we want js executed without order (like async, but it blocks parsing)
- we want to execute after all initial parsing is done (like defer, but again, order)

How Next.js renders initial page:
- Next.js is using combination of "preload" in head (to load as soon as possible) and "async" in bottom (it still will block parsing, js always does that, but when in the bottom - all parsing is already done)

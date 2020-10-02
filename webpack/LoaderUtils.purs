module LoaderUtils where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy
import Webpack.Loader

foreign import _getOptions :: EffectFn1 LoaderContext Foreign

getOptions = runEffectFn1 _getOptions

module LoaderUtils where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy
import Webpack.Loader
import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Core (Json)

foreign import _getOptions :: EffectFn1 LoaderContext Json

getOptions :: LoaderContext -> Effect Json
getOptions = runEffectFn1 _getOptions

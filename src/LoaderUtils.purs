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
import Node.URL (Query)

foreign import _getOptions :: EffectFn1 LoaderContext Query

getOptions :: LoaderContext -> Effect Query
getOptions = runEffectFn1 _getOptions

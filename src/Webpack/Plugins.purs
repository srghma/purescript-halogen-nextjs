module Webpack.Plugins where

import Control.Promise
import Effect.Uncurried
import Protolude
import Webpack.Types

import Data.Array as Array
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Foreign (Foreign)

foreign import webpack ::
  { _DefinePlugin :: Foreign -> WebpackPluginInstance
  , _ProvidePlugin :: forall options . { | options } ->  WebpackPluginInstance
  , _NoEmitOnErrorsPlugin :: WebpackPluginInstance
  , optimize ::
    { _LimitChunkCountPlugin :: forall options . { | options } ->  WebpackPluginInstance
    }
  }

module Webpack.Plugins where

import Webpack.Types (WebpackPluginInstance)
import Foreign (Foreign)

foreign import webpack ::
  { _DefinePlugin :: Foreign -> WebpackPluginInstance
  , _ProvidePlugin :: forall options. { | options } -> WebpackPluginInstance
  , _NoEmitOnErrorsPlugin :: WebpackPluginInstance
  , optimize ::
    { _LimitChunkCountPlugin :: forall options. { | options } -> WebpackPluginInstance
    }
  }

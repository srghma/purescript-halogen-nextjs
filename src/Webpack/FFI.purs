module Webpack.FFI where

import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Foreign.Object (Object)
import Foreign.Object as Object
import Webpack.Types

foreign import webpackEntrypontName :: EffectFn1 WebpackEntrypont String

foreign import webpackEntrypontGetFiles :: EffectFn1 WebpackEntrypont (Array String)

foreign import rawSource :: String -> RawSource

foreign import compilationSetAsset :: EffectFn3 Compilation String RawSource Unit

foreign import compilationGetEntrypoints :: EffectFn1 Compilation (Object WebpackEntrypont)


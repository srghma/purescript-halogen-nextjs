module Webpack.FFI where

import Data.Function.Uncurried
import Effect.Uncurried
import Protolude
import Webpack.Types

import Foreign (Foreign)
import Foreign as Foreign
import Foreign.JsMap (JsMap)
import Foreign.JsMap as JsMap
import Foreign.Object (Object)
import Foreign.Object as Object
import Node.Buffer (Buffer)
import Unsafe.Coerce (unsafeCoerce)

foreign import webpackEntrypontName :: EffectFn1 WebpackEntrypont String

foreign import webpackEntrypontGetFiles :: EffectFn1 WebpackEntrypont (Array String)

foreign import _rawSource :: Foreign -> RawSource

rawSourceFromString :: String -> RawSource
rawSourceFromString = _rawSource <<< unsafeCoerce

rawSourceFromBuffer :: Buffer -> RawSource
rawSourceFromBuffer = _rawSource <<< unsafeCoerce

foreign import compilationSetAsset :: EffectFn3 Compilation String RawSource Unit

foreign import compilationGetEntrypoints :: EffectFn1 Compilation (JsMap String WebpackEntrypont)

foreign import mkPlugin :: Fn2 String (EffectFn2 Compilation (Effect Unit) Unit) WebpackPluginInstance

mkPluginSync :: String -> (Compilation -> Effect Unit) -> WebpackPluginInstance
mkPluginSync name doWork = runFn2 mkPlugin name $ mkEffectFn2 \compilation callback -> do
  doWork compilation
  callback


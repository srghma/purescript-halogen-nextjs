module Firstline where

import Control.Promise (Promise)
import Effect.Uncurried (EffectFn1)
import Protolude
import Pathy (Abs, File, Path)

firstline :: Path Abs File -> Aff String
firstline = undefined

foreign import _firstline :: EffectFn1 String (Promise String)

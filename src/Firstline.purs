module Firstline where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy

firstline :: Path Abs File -> Aff String
firstline = undefined

foreign import _firstline :: EffectFn1 String (Promise String)

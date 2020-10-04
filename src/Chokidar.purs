module Chokidar where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray

data ChokidarEvent

foreign import _watch ::
  EffectFn1
  { files   :: NonEmptyArray String
  , onAll   :: EffectFn2 ChokidarEvent String Unit
  }
  Unit

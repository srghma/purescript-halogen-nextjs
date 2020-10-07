module Chokidar where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import FRP.Event (Event)
import FRP.Event as Event
import Effect.Ref as Ref

-- | data ChokidarEvent

foreign import _watch ::
  EffectFn1
  { files :: NonEmptyArray String
  -- | , options ::
  -- |   { ignored :: String
  -- |   , ignoreInitial :: Boolean
  -- |   , cwd :: String
  -- |   }
  , onAll :: EffectFn1 String Unit
  }
  (Effect Unit)

watch :: NonEmptyArray String -> Event String
watch files = Event.makeEvent \push -> runEffectFn1 _watch { files, onAll: mkEffectFn1 push }

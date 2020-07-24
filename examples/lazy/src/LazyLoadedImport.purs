module Example.Lazy.LazyLoadedImport where

import Data.Const
import Protolude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Time.Duration (Milliseconds(..))
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect.Aff (delay)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Elements.Keyed as HK
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

foreign import lazyLoadedImport_ :: forall q i o m . Effect (Promise { component :: H.Component q i o m })

lazyLoadedImport :: forall q i o m . Aff (H.Component q i o m)
lazyLoadedImport = do
  delay (Milliseconds 3000.0)
  Promise.toAffE lazyLoadedImport_ <#> _.component

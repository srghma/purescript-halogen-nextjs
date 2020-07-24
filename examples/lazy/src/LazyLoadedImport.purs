module Example.Lazy.LazyLoadedImport where

import Protolude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Elements.Keyed as HK
import Halogen.HTML.Properties as HP
import Data.Const
import Data.Symbol (SProxy(..))
import Control.Promise as Promise
import Control.Promise (Promise)

foreign import lazyLoadedImport_ :: forall q i o m . Effect (Promise { component :: H.Component q i o m })

lazyLoadedImport :: forall q i o m . Aff (H.Component q i o m)
lazyLoadedImport = Promise.toAffE lazyLoadedImport_ <#> _.component

module Example.Lazy.LazyLoaded (component) where

import Protolude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Elements.Keyed as HK
import Halogen.HTML.Properties as HP
import Data.Const
import Data.Symbol (SProxy(..))

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
    }

render :: forall m query. Unit -> H.ComponentHTML query () m
render _ =
  HH.div_
    [ HH.text "I'm lazy loaded child (LOADED)"
    ]

module Nextjs.PageImplementations.Buttons.Buttons (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = Unit

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: forall m. State -> H.ComponentHTML Void () m
render state = HH.div_ [ HH.text "Button" ]

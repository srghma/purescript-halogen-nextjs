module Nextjs.PageImplementations.Buttons.IconButtons (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH

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

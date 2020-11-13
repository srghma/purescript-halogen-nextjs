module Example.DynamicInput.Container (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH

component :: forall q o m state. Show state => H.Component q state o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: forall m state. Show state => state -> H.ComponentHTML Void _
 m
render state =
  HH.div_
    [ HH.p_ [ HH.text (show state) ]
    ]

module Example.DynamicInput.Container (component) where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
import Example.Components.Button as Button
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

component :: forall q o m state. Show state => H.Component q state o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: forall m state. Show state => state -> H.ComponentHTML Void _ m
render state =
  HH.div_
    [ HH.p_ [ HH.text (show state) ]
    ]

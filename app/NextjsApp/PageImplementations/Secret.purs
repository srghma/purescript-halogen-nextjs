module NextjsApp.PageImplementations.Secret (component) where

import Protolude
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)

type Query
  = Const Void

type Input
  = Unit

type Message
  = Void

type State
  = Unit

type Action
  = Void

type ChildSlots
  = ()

component :: H.Component Query Input Message AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: State -> HH.ComponentHTML Action ChildSlots AppM
render _ = HH.div_ [ HH.text "Secret" ]

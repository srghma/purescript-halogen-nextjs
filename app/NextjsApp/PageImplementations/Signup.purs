module NextjsApp.PageImplementations.Signup (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import NextjsApp.Link as NextjsApp.Link
import NextjsApp.Route (Examples(..), Route(..))

type Query = Const Void

type Input = Unit

type Message = Void

type State = Unit

type Action = Void

type ChildSlots = ()

component :: H.Component Query Input Message AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: State -> HH.ComponentHTML Action ChildSlots AppM
render _ = HH.div_ [ HH.text "Signup" ]
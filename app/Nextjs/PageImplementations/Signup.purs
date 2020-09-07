module Nextjs.PageImplementations.Signup (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import Nextjs.AppM (AppM)
import Nextjs.Link as Nextjs.Link
import Nextjs.Route (Examples(..), Route(..))

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

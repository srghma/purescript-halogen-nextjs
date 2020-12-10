module NextjsApp.Link.Types where

import Halogen as H
import NextjsApp.Route as NextjsApp.Route
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import Protolude

data Action
  = Initialize
  | Navigate Web.UIEvent.MouseEvent.MouseEvent
  | LinkIsInViewport H.SubscriptionId

type State
  = { route :: (Variant NextjsApp.Route.WebRoutesWithParamRow)
    , text :: String
    }

type Query
  = Const Void

type Message
  = Void

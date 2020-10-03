module NextjsApp.Link.Types where

import Halogen (SubscriptionId) as H
import NextjsApp.Route as NextjsApp.Route
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import Protolude

data Action
  = Initialize
  | Navigate Web.UIEvent.MouseEvent.MouseEvent
  | LinkIsInViewport H.SubscriptionId

type State =
  { route :: NextjsApp.Route.Route
  , text :: String
  }

type Query = Const Void

type Message = Void
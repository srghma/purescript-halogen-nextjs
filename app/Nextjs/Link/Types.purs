module Nextjs.Link.Types where

import Halogen (SubscriptionId) as H
import Nextjs.Route as Nextjs.Route
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import Protolude

data Action
  = Initialize
  | Navigate Web.UIEvent.MouseEvent.MouseEvent
  | LinkIsInViewport H.SubscriptionId

type State =
  { route :: Nextjs.Route.Route
  , text :: String
  }

type Query = Const Void

type Message = Void

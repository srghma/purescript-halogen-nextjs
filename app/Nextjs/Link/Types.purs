module Nextjs.Link.Types where

import Protolude

import Halogen (SubscriptionId) as H
import Nextjs.Route as Nextjs.Route
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent

data Action
  = Initialize
  | Finalize
  | Navigate Web.UIEvent.MouseEvent.MouseEvent
  | LinkIsInViewport H.SubscriptionId

type State =
  { route :: Nextjs.Route.Route
  , text :: String
  }

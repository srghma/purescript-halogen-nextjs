module Nextjs.Link.Types where

import Protolude

import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import Nextjs.Route as Nextjs.Route

data Action linkActionRest
  = Initialize
  | Finalize
  | Navigate Web.UIEvent.MouseEvent.MouseEvent
  | RestAction linkActionRest

type State =
  { route :: Nextjs.Route.Route
  , text :: String
  }

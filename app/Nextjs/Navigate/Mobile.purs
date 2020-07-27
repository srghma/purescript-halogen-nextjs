module Nextjs.Navigate.Mobile where

import Protolude

import FRP.Event (EventIO)
import Nextjs.Route as Nextjs.Route

navigate :: EventIO Nextjs.Route.Route -> Nextjs.Route.Route -> Effect Unit
navigate newRouteEventIO route = newRouteEventIO.push route

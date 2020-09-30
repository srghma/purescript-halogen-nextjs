module NextjsApp.Navigate.Mobile where

import Protolude

import FRP.Event (EventIO)
import NextjsApp.Route as NextjsApp.Route

navigate :: EventIO NextjsApp.Route.Route -> NextjsApp.Route.Route -> Effect Unit
navigate newRouteEventIO route = newRouteEventIO.push route

module NextjsApp.Navigate.Client where

import Protolude

import NextjsApp.Route as NextjsApp.Route
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Foreign as Foreign

navigate :: Routing.PushState.PushStateInterface -> NextjsApp.Route.Route -> Effect Unit
navigate pushStateInterface route =
  let path = Routing.Duplex.print NextjsApp.Route.routeCodec route
   in pushStateInterface.pushState (Foreign.unsafeToForeign unit) path

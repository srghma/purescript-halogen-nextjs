module NextjsApp.Navigate.Client where

import Protolude
import NextjsApp.Route as NextjsApp.Route
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Foreign as Foreign
import NextjsApp.RouteDuplexCodec as NextjsApp.RouteDuplexCodec

navigate :: Routing.PushState.PushStateInterface -> NextjsApp.Route.Route -> Effect Unit
navigate pushStateInterface route =
  let
    path = Routing.Duplex.print NextjsApp.RouteDuplexCodec.routeCodec route
  in
    pushStateInterface.pushState (Foreign.unsafeToForeign unit) path

module NextjsApp.Navigate.Client where

import Protolude

import Foreign as Foreign

import NextjsApp.Route as NextjsApp.Route
import NextjsApp.WebRouteDuplexCodec as NextjsApp.WebRouteDuplexCodec
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState

navigate :: Routing.PushState.PushStateInterface -> (Variant NextjsApp.Route.WebRoutesWithParamRow) -> Effect Unit
navigate pushStateInterface route =
  let
    path = Routing.Duplex.print NextjsApp.WebRouteDuplexCodec.routeCodec route
  in
    pushStateInterface.pushState (Foreign.unsafeToForeign unit) path

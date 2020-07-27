module Nextjs.Navigate.Client where

import Protolude

import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Foreign as Foreign

navigate :: Routing.PushState.PushStateInterface -> Nextjs.Route.Route -> Effect Unit
navigate pushStateInterface route =
  let path = Routing.Duplex.print Nextjs.Route.routeCodec route
   in pushStateInterface.pushState (Foreign.unsafeToForeign unit) path

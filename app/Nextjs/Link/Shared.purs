module Nextjs.Link.Shared where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Nextjs.Capability.Navigate as Nextjs.Capability.Navigate
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import Web.Event.Event as Web.Event.Event
import Nextjs.ElementIsInViewport as Nextjs.ElementIsInViewport
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import FRP.Event as FRP.Event
import Web.HTML as Web.HTML
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.PageLoader as Nextjs.PageLoader

data Action other
  = Other other
  | Navigate Web.UIEvent.MouseEvent.MouseEvent

type State =
  { route :: Nextjs.Route.Route
  , text :: String
  }

elementLabel :: H.RefLabel
elementLabel = H.RefLabel "link"

render :: forall m other. State -> H.ComponentHTML (Action other) () m
render state =
  HH.a
    [ HP.href (Routing.Duplex.print Nextjs.Route.routeCodec state.route) -- TODO: can cache
    , HE.onClick Navigate
    , HP.ref elementLabel
    ]
    [ HH.text state.text
    ]

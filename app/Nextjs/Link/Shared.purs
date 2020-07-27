module Nextjs.Link.Shared where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
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
import Nextjs.Navigate as Nextjs.Navigate

data Action restAction
  = RestAction restAction
  | Navigate Web.UIEvent.MouseEvent.MouseEvent

type State =
  { route :: Nextjs.Route.Route
  , text :: String
  }

type Env r =
  { navigate :: Nextjs.Route.Route -> Effect Unit
  | r
  }

elementLabel :: H.RefLabel
elementLabel = H.RefLabel "link"

render :: forall m restAction. State -> H.ComponentHTML (Action restAction) () m
render state =
  HH.a
    [ HP.href (Routing.Duplex.print Nextjs.Route.routeCodec state.route) -- TODO: can cache
    , HE.onClick Navigate
    , HP.ref elementLabel
    ]
    [ HH.text state.text
    ]

handleActionNavigate
  :: forall restAction slot m r
   . MonadEffect m
  => MonadAsk (Env r) m
  => Web.UIEvent.MouseEvent.MouseEvent
  -> H.HalogenM State (Action restAction) slot Void m Unit
handleActionNavigate mouseEvent = do
  -- TODO: ignore newtab clicks https://github.com/vercel/next.js/blob/8dd3d2a8e2b266611a60b9550d2ecac02f14fd57/packages/next/client/link.tsx#L171-L182
  H.liftEffect $ Web.Event.Event.preventDefault (Web.UIEvent.MouseEvent.toEvent mouseEvent)

  state <- H.get
  Nextjs.Navigate.navigate state.route

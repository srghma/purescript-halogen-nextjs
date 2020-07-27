module Nextjs.Link.Mobile where

import Nextjs.Link.Shared
import Protolude

import FRP.Event as FRP.Event
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Nextjs.ElementIsInViewport as Nextjs.ElementIsInViewport
import Nextjs.Link.Shared as Nextjs.Link.Shared
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Web.Event.Event as Web.Event.Event
import Web.HTML as Web.HTML
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent

type Action = Nextjs.Link.Shared.Action Void

component
  :: forall m r
   . MonadEffect m
  => MonadAsk (Env r) m
  => H.Component (Const Void) State Void m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

handleAction
  :: forall m r
   . MonadEffect m
  => MonadAsk (Env r) m
  => Action
  -> H.HalogenM State Action () Void m Unit
handleAction (Navigate mouseEvent) = handleActionNavigate mouseEvent
handleAction (RestAction _) = mempty

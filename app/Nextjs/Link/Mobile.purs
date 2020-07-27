module Nextjs.Link.Mobile where

import Protolude

import Nextjs.AppM
import FRP.Event as FRP.Event
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Nextjs.ElementIsInViewport as Nextjs.ElementIsInViewport
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

type RestAction = Void

mkLinkHandleActions :: EnvLinkHandleActions
mkLinkHandleActions = mkEnvLinkHandleActions mkLinkHandleActionsSpec

mkLinkHandleActionsSpec
  :: forall r
  . EnvLinkHandleActionsSpec RestAction
mkLinkHandleActionsSpec =
  { handleInitialize: pure unit
  , handleFinalize: pure unit
  , handleRestAction: absurd
  }

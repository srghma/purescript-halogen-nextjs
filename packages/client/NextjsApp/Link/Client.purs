module NextjsApp.Link.Client where

import Protolude
import NextjsApp.AppM (EnvLinkHandleActions)
import FRP.Event as FRP.Event
import Halogen as H
import NextjsApp.ElementIsInViewport as NextjsApp.ElementIsInViewport
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import NextjsApp.PageLoader as NextjsApp.PageLoader
import NextjsApp.Route as NextjsApp.Route
import Web.HTML as Web.HTML
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import NextjsApp.Link.Types (Action(..), State)
import NextjsApp.Link.Lib (elementLabel)

type Context
  = { intersectionObserver :: Web.IntersectionObserver.IntersectionObserver
    , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
    , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
    , document :: Web.HTML.HTMLDocument
    , head :: Web.HTML.HTMLHeadElement
    }

mkLinkHandleActions ::
  Context ->
  EnvLinkHandleActions
mkLinkHandleActions = \context ->
  { handleInitialize:
    H.getHTMLElementRef elementLabel
      >>= traverse_ \element -> do
          H.liftEffect $ Web.IntersectionObserver.observe context.intersectionObserver (Web.HTML.HTMLElement.toElement element)
          H.subscribe' \sid ->
            NextjsApp.ElementIsInViewport.elementIsInViewport
              context.intersectionObserverEvent
              (LinkIsInViewport sid)
              (Web.HTML.HTMLElement.toElement element)
  , handleLinkIsInViewport:
    \sid -> do
      -- | traceM { message: "I'm in viewport" }
      -- once we know the link is in viewport
      -- we won't need events anymore
      -- unsubscribe from observer
      H.getHTMLElementRef elementLabel >>= traverse_ \element -> finalizeIntersectionObserver context.intersectionObserver element
      -- unsubscribe from events
      H.unsubscribe sid
      -- now prefetch the page dependencies
      { route } <- H.get
      let
        (pageManifest :: NextjsApp.Manifest.PageManifest.PageManifest) = NextjsApp.Route.lookupFromRouteIdMapping route context.clientPagesManifest
      H.liftEffect $ NextjsApp.PageLoader.appendPagePrefetch pageManifest context.document context.head
  }
  where
  finalizeIntersectionObserver ::
    forall m action.
    MonadEffect m =>
    Web.IntersectionObserver.IntersectionObserver ->
    Web.HTML.HTMLElement ->
    H.HalogenM State action () Void m Unit
  finalizeIntersectionObserver intersectionObserver element =
    H.liftEffect
      $ Web.IntersectionObserver.unobserve
          intersectionObserver
          (Web.HTML.HTMLElement.toElement element)

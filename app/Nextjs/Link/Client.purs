module Nextjs.Link.Client where

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
import Nextjs.Navigate as Nextjs.Navigate
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Unsafe.Coerce (unsafeCoerce)
import Web.Event.Event as Web.Event.Event
import Web.HTML as Web.HTML
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import Nextjs.Link.Types
import Nextjs.Link.Lib

type Context =
  { intersectionObserver      :: Web.IntersectionObserver.IntersectionObserver
  , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
  , clientPagesManifest       :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  , document                  :: Web.HTML.HTMLDocument
  , head                      :: Web.HTML.HTMLHeadElement
  }

finalizeIntersectionObserver
  :: forall m action
   . MonadEffect m
  => Web.IntersectionObserver.IntersectionObserver
  -> Web.HTML.HTMLElement
  -> H.HalogenM State action () Void m Unit
finalizeIntersectionObserver intersectionObserver element =
  H.liftEffect $
    Web.IntersectionObserver.unobserve
    intersectionObserver
    (Web.HTML.HTMLElement.toElement element)

mkLinkHandleActions
  :: Context
  -> EnvLinkHandleActions
mkLinkHandleActions context =
  { handleInitialize: H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
      H.liftEffect $ Web.IntersectionObserver.observe context.intersectionObserver (Web.HTML.HTMLElement.toElement element)
      H.subscribe' \sid ->
        Nextjs.ElementIsInViewport.elementIsInViewport
        context.intersectionObserverEvent
        (LinkIsInViewport sid)
        (Web.HTML.HTMLElement.toElement element)
  , handleFinalize: H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
      -- unsubscribe from observer on finalize too, TODO: maybe ignore it?
      finalizeIntersectionObserver context.intersectionObserver element
  , handleLinkIsInViewport: \sid -> do
      -- | traceM { message: "I'm in viewport" }

      -- once we know the link is in viewport
      -- we won't need events anymore

      -- unsubscribe from observer
      H.getHTMLElementRef elementLabel >>= traverse_ \element -> finalizeIntersectionObserver context.intersectionObserver element

      -- unsubscribe from events
      H.unsubscribe sid

      -- now prefetch the page dependencies
      { route } <- H.get
      let (pageManifest :: Nextjs.Manifest.PageManifest.PageManifest) = Nextjs.Route.extractFromPagesRec route context.clientPagesManifest

      H.liftEffect $ Nextjs.PageLoader.appendPagePrefetch pageManifest context.document context.head
  }

module Nextjs.Link.Client where

import Protolude (class MonadEffect, Unit, Void, bind, discard, traverse_, ($), (>>=))

import Nextjs.AppM (EnvLinkHandleActions)
import FRP.Event as FRP.Event
import Halogen as H
import Nextjs.ElementIsInViewport as Nextjs.ElementIsInViewport
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Web.HTML as Web.HTML
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import Nextjs.Link.Types (Action(..), State)
import Nextjs.Link.Lib (elementLabel)

type Context =
  { intersectionObserver      :: Web.IntersectionObserver.IntersectionObserver
  , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
  , clientPagesManifest       :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  , document                  :: Web.HTML.HTMLDocument
  , head                      :: Web.HTML.HTMLHeadElement
  }

mkLinkHandleActions
  :: Context
  -> EnvLinkHandleActions
mkLinkHandleActions = \context ->
  { handleInitialize: H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
      H.liftEffect $ Web.IntersectionObserver.observe context.intersectionObserver (Web.HTML.HTMLElement.toElement element)
      H.subscribe' \sid ->
        Nextjs.ElementIsInViewport.elementIsInViewport
        context.intersectionObserverEvent
        (LinkIsInViewport sid)
        (Web.HTML.HTMLElement.toElement element)
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
  where
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

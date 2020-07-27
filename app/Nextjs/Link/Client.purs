module Nextjs.Link.Client where

import Nextjs.AppM
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

type Context =
  { intersectionObserver      :: Web.IntersectionObserver.IntersectionObserver
  , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
  , clientPagesManifest       :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  , document                  :: Web.HTML.HTMLDocument
  , head                      :: Web.HTML.HTMLHeadElement
  }

data RestAction
  = Initialize
  | Finalize
  | LinkIsInViewport H.SubscriptionId

type Action = Nextjs.Link.Shared.Action RestAction

component
  :: forall m r
   . Context
  -> H.Component (Const Void) State Void AppM
component context =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval
      { handleAction = handleAction context
      , initialize = Just (RestAction Initialize)
      , finalize = Just (RestAction Finalize)
      }
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

handleRestAction
  :: forall r
   . Context
  -> RestAction
  -> H.HalogenM State RestAction () Void AppM Unit
handleRestAction context Initialize = H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
  H.liftEffect $ Web.IntersectionObserver.observe context.intersectionObserver (Web.HTML.HTMLElement.toElement element)
  H.subscribe' \sid ->
    Nextjs.ElementIsInViewport.elementIsInViewport
    context.intersectionObserverEvent
    (LinkIsInViewport sid)
    (Web.HTML.HTMLElement.toElement element)
handleRestAction context (LinkIsInViewport sid) = do
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
handleRestAction context Finalize = H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
  -- unsubscribe from observer on finalize too, TODO: maybe ignore it?
  finalizeIntersectionObserver context.intersectionObserver element

handleAction
  :: forall r
   . Context
  -> Action
  -> H.HalogenM State Action () Void AppM Unit
handleAction context (Navigate mouseEvent) = handleActionNavigate mouseEvent
handleAction context (RestAction restAction) = unsafeCoerce $ handleRestAction context restAction

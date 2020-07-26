module Lib.Link (component) where

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

type Env r =
  { intersectionObserver :: Web.IntersectionObserver.IntersectionObserver
  , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
  , clientPagesManifest :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  , document :: Web.HTML.HTMLDocument
  , head :: Web.HTML.HTMLHeadElement
  | r
  }

type State = { route :: Nextjs.Route.Route, text :: String }

data Action
  = Initialize
  | Finalize
  | LinkIsInViewport H.SubscriptionId
  | Navigate Web.UIEvent.MouseEvent.MouseEvent

component
  :: forall m r
   . MonadEffect m
  => Nextjs.Capability.Navigate.Navigate m
  => MonadAsk (Env r) m
  => H.Component (Const Void) State Void m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction, initialize = Just Initialize, finalize = Just Finalize }
    }

finalizeIntersectionObserver
  :: forall m
   . MonadEffect m
  => Web.IntersectionObserver.IntersectionObserver
  -> Web.HTML.HTMLElement
  -> H.HalogenM State Action () Void m Unit
finalizeIntersectionObserver intersectionObserver element = H.liftEffect $ Web.IntersectionObserver.unobserve intersectionObserver (Web.HTML.HTMLElement.toElement element)

elementLabel :: RefLabel
elementLabel = H.RefLabel "link"

handleAction
  :: forall m r
   . MonadEffect m
  => Nextjs.Capability.Navigate.Navigate m
  => MonadAsk (Env r) m
  => Action
  -> H.HalogenM State Action () Void m Unit
handleAction Initialize = H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
  env <- ask
  H.liftEffect $ Web.IntersectionObserver.observe env.intersectionObserver (Web.HTML.HTMLElement.toElement element)
  H.subscribe' \sid -> Nextjs.ElementIsInViewport.elementIsInViewport env.intersectionObserverEvent (LinkIsInViewport sid) (Web.HTML.HTMLElement.toElement element)
handleAction (LinkIsInViewport sid) = do
  traceM { message: "I'm in viewport" }

  -- once we know the link is in viewport
  -- we won't need events anymore
  env <- ask
  H.getHTMLElementRef elementLabel >>= traverse_ \element -> finalizeIntersectionObserver env.intersectionObserver element -- unsubscribe from observer
  H.unsubscribe sid -- unsubscribe from events

  -- now prefetch the page dependencies
  { route } <- H.get
  let (pageManifest :: Nextjs.Manifest.PageManifest.PageManifest) = Nextjs.Route.extractFromPagesRec route env.clientPagesManifest

  H.liftEffect $ Nextjs.PageLoader.appendPagePrefetch pageManifest env.document env.head
handleAction (Navigate mouseEvent) = do
  -- TODO: ignore newtab clicks https://github.com/vercel/next.js/blob/8dd3d2a8e2b266611a60b9550d2ecac02f14fd57/packages/next/client/link.tsx#L171-L182
  H.liftEffect $ Web.Event.Event.preventDefault (Web.UIEvent.MouseEvent.toEvent mouseEvent)

  state <- H.get
  Nextjs.Capability.Navigate.navigate state.route
handleAction Finalize = do
  env <- ask
  H.getHTMLElementRef elementLabel >>= traverse_ \element -> finalizeIntersectionObserver env.intersectionObserver element -- unsubscribe from observer on finalize too, TODO: maybe ignore it?

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.a
    [ HP.href (Routing.Duplex.print Nextjs.Route.routeCodec state.route)
    , HE.onClick Navigate
    , HP.ref elementLabel
    ]
    [ HH.text state.text
    ]

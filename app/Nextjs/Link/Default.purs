module Nextjs.Link.Default where

import Nextjs.AppM
import Protolude

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

component :: H.Component (Const Void) State Void AppM
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval
      { handleAction = handleAction
      , initialize = Just Initialize
      , finalize = Just Finalize
      }
    }

render :: State -> H.ComponentHTML Action () AppM
render state =
  HH.a
    [ HP.href (Routing.Duplex.print Nextjs.Route.routeCodec state.route) -- TODO: can cache
    , HE.onClick Navigate
    , HP.ref elementLabel
    ]
    [ HH.text state.text
    ]

handleActionNavigate
  :: forall slot
   . Web.UIEvent.MouseEvent.MouseEvent
  -> H.HalogenM State Action slot Void AppM Unit
handleActionNavigate mouseEvent = do
  -- TODO: ignore newtab clicks https://github.com/vercel/next.js/blob/8dd3d2a8e2b266611a60b9550d2ecac02f14fd57/packages/next/client/link.tsx#L171-L182
  H.liftEffect $ Web.Event.Event.preventDefault (Web.UIEvent.MouseEvent.toEvent mouseEvent)

  state <- H.get
  traceM { message: "navigating", route: state.route }
  Nextjs.Navigate.navigate state.route

handleAction :: Action -> H.HalogenM State Action () Void AppM Unit
handleAction action = ask >>= \env ->
    case action of
         Navigate mouseEvent -> handleActionNavigate mouseEvent
         Initialize -> env.linkHandleActions.handleInitialize
         Finalize -> env.linkHandleActions.handleFinalize
         LinkIsInViewport subscriptionId -> env.linkHandleActions.handleLinkIsInViewport subscriptionId

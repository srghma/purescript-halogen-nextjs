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

import NextjsApp.AppM (AppM)
import Protolude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import NextjsApp.Navigate as NextjsApp.Navigate
import Routing.Duplex as Routing.Duplex
import Web.Event.Event as Web.Event.Event
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import NextjsApp.Link.Types (Action(..), Message, Query, State)
import NextjsApp.Link.Lib (elementLabel)
import NextjsApp.WebRouteDuplexCodec as NextjsApp.WebRouteDuplexCodec

component :: H.Component Query State Message AppM
component =
  H.mkComponent
    { initialState: identity
    , render: \state ->
        HH.a
          -- TODO
          -- | [ HP.href (Routing.Duplex.print NextjsApp.WebRouteDuplexCodec.routeCodec state.route) -- TODO: can cache
          [ HE.onClick Navigate
          , HP.ref elementLabel
          ]
          [ HH.text state.text
          ]
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction = \action ->
                ask
                  >>= \env -> case action of
                      Navigate mouseEvent ->
                        -- TODO: ignore newtab clicks https://github.com/vercel/next.js/blob/8dd3d2a8e2b266611a60b9550d2ecac02f14fd57/packages/next/client/link.tsx#L171-L182
                        H.liftEffect $ Web.Event.Event.preventDefault (Web.UIEvent.MouseEvent.toEvent mouseEvent)

                        H.gets _.route >>= NextjsApp.Navigate.navigate
                      Initialize -> H.getHTMLElementRef elementLabel >>= traverse_ \element -> do
                        H.liftEffect $ Web.IntersectionObserver.observe context.intersectionObserver (Web.HTML.HTMLElement.toElement element)

                        H.subscribe' \subscriptionId ->
                          NextjsApp.ElementIsInViewport.elementIsInViewport
                            context.intersectionObserverEvent
                            (LinkIsInViewport subscriptionId)
                            (Web.HTML.HTMLElement.toElement element)
                      LinkIsInViewport subscriptionId -> do
                        -- | traceM { message: "I'm in viewport" }
                        -- once we know the link is in viewport
                        -- we don't need events anymore
                        -- unsubscribe from observer
                        H.getHTMLElementRef elementLabel
                          >>= traverse_ \element -> H.liftEffect $
                              Web.IntersectionObserver.unobserve
                              context.intersectionObserver
                              (Web.HTML.HTMLElement.toElement element)

                        -- unsubscribe from events
                        H.unsubscribe subscriptionId

                        -- now prefetch the page dependencies
                        route <- H.gets _.route

                        let (pageManifest :: NextjsApp.Manifest.PageManifest.PageManifest) =
                              NextjsApp.WebRouteToPageServer.webRouteToPageSpecBoxed
                              route
                              context.clientPagesManifest

                        H.liftEffect $ NextjsApp.PageLoader.appendPagePrefetch
                          pageManifest
                          context.document
                          context.head
            , initialize = Just Initialize
            }
    }

type Context
  = { intersectionObserver :: Web.IntersectionObserver.IntersectionObserver
    , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
    , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
    , document :: Web.HTML.HTMLDocument
    , head :: Web.HTML.HTMLHeadElement
    }

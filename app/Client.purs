module Nextjs.Client where

import Protolude

import Data.Argonaut.Core (Json) as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Either (hush)
import Effect.Aff as Effect.Aff
import Halogen as H
import Halogen.Aff.Util as Halogen.Aff.Util
import Halogen.VDom.Driver as Halogen.VDom.Driver
import Nextjs.AppM (Env, runAppM)
import Nextjs.Constants as Nextjs.Constants
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Lib.Utils (findJsonFromScriptElement, getPathWithoutOrigin)
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.Router as Nextjs.Router
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Web.DOM as Web.DOM
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.Window as Web.HTML.Window
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import FRP.Event as FRP.Event
import Web.HTML.HTMLHeadElement as Web.HTML.HTMLHeadElement
import Nextjs.WebShared

navigate :: forall output . H.HalogenIO Nextjs.Router.Query output Aff -> Maybe Nextjs.Route.Route -> Nextjs.Route.Route -> Effect Unit
navigate halogenIO oldRoute newRoute = when (oldRoute /= Just newRoute) do
  launchAff_ $ halogenIO.query $ H.mkTell $ Nextjs.Router.Navigate newRoute

getPrerenderedJson :: Aff ArgonautCore.Json
getPrerenderedJson = findJsonFromScriptElement (Web.DOM.ParentNode.QuerySelector Nextjs.Constants.pagesDataId)

getInitialRouteFromLocation :: Aff Nextjs.Route.Route
getInitialRouteFromLocation = do
  initialRoute <- hush <<< Routing.Duplex.parse Nextjs.Route.routeCodec <$> liftEffect (Web.HTML.window >>= Web.HTML.Window.location >>= getPathWithoutOrigin)
  initialRoute' <- maybe (throwError (error $ "Could not find initialRoute")) pure initialRoute
  pure initialRoute'

intersectionObserverEventAndCallback :: Effect
  { intersectionObserverCallback :: Array Web.IntersectionObserverEntry.IntersectionObserverEntry -> Web.IntersectionObserver.IntersectionObserver -> Effect Unit
  , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
  }
intersectionObserverEventAndCallback = do
  { event, push } <- FRP.Event.create
  pure
    { intersectionObserverCallback: \entries _ -> push entries
    , intersectionObserverEvent: event
    }

intersectionObserverOptions :: Web.IntersectionObserver.IntersectionObserverInit
intersectionObserverOptions = Web.IntersectionObserver.defaultIntersectionObserverInit { rootMargin = "200px" }

main :: Effect Unit
main = do
  { window, document, body, head } <- getHtmlEntities

  { intersectionObserverEvent, intersectionObserverCallback } <- intersectionObserverEventAndCallback
  (intersectionObserver :: Web.IntersectionObserver.IntersectionObserver) <- Web.IntersectionObserver.create intersectionObserverCallback intersectionObserverOptions

  Effect.Aff.launchAff_ do
    (clientPagesManifest :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest) <- Nextjs.Manifest.ClientPagesManifest.getBuildManifest

    pageRegisteredEvent <- liftEffect Nextjs.PageLoader.createPageRegisteredEvent

    -- https://github.com/slamdata/purescript-routing/blob/v8.0.0/GUIDE.md
    -- https://github.com/natefaubion/purescript-routing-duplex/blob/v0.2.0/README.md
    pushStateInterface <- liftEffect Routing.PushState.makeInterface

    -- first we'll get the route the user landed on
    route <- getInitialRouteFromLocation

    page <- Nextjs.PageLoader.loadPage clientPagesManifest document body head pageRegisteredEvent route

    (pageSpecWithInputBoxed :: Nextjs.Lib.Page.PageSpecWithInputBoxed) <-
      Nextjs.Lib.Page.pageToPageSpecWithInputBoxedWivenInitialJson getPrerenderedJson page >>=
      (throwError <<< error <<< ArgonautCodecs.printJsonDecodeError) \/ pure

    let (env :: Env) =
          { pushStateInterface
          , intersectionObserver
          , intersectionObserverEvent
          , document
          , head
          , clientPagesManifest
          }

    let initialState =
          { pageRegisteredEvent
          , document
          , body
          , head
          , clientPagesManifest
          , currentPageInfo: Just
            { pageSpecWithInputBoxed
            , route
            }
          }

    let component = H.hoist (runAppM env) Nextjs.Router.clientComponent

    rootElement <- Halogen.Aff.Util.awaitElement (Web.DOM.ParentNode.QuerySelector "#root")
    halogenIO <- Halogen.VDom.Driver.hydrateUI component initialState rootElement

    void $ liftEffect $ Routing.PushState.matchesWith (Routing.Duplex.parse Nextjs.Route.routeCodec) (navigate halogenIO) pushStateInterface

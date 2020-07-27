module Nextjs.Entries.Mobile where

import Protolude
import Cordova.EventTypes as Cordova
import Data.Argonaut.Core (Json) as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Either (hush)
import Effect.Aff as Effect.Aff
import FRP.Event as FRP.Event
import Halogen as H
import Halogen.Aff.Util as Halogen.Aff.Util
import Halogen.VDom.Driver as Halogen.VDom.Driver
import Nextjs.AppM (Env, runAppM)
import Nextjs.Constants as Nextjs.Constants
import Nextjs.Lib.Api (throwApiError) as Nextjs.Lib.Api
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Lib.Utils (findJsonFromScriptElement, getHtmlEntities, getPathWithoutOrigin, selectElementRequired)
import Nextjs.Link.Mobile as Nextjs.Link.Mobile
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Navigate.Mobile as Nextjs.Navigate.Mobile
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.RouteToPage as Nextjs.RouteToPage
import Nextjs.Router.Mobile as Nextjs.Router.Mobile
import Nextjs.Router.Shared as Nextjs.Router.Shared
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.Window as Web.HTML.Window
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry

onDeviceReady
  :: forall m e
   . Web.HTML.HTMLDocument
  -> Effect Unit
  -> Effect Unit
onDeviceReady document callback = do
  eventListener' <- eventListener \_ -> callback
  addEventListener Cordova.deviceready eventListener' false (Web.HTML.HTMLDocument.toEventTarget document)

main :: Effect Unit
main = do
  { window, document, body, head } <- getHtmlEntities

  (newRouteEventIO :: FRP.Event.EventIO Nextjs.Route.Route) <- FRP.Event.create

  -- first we'll get the route the user landed on
  let (route :: Nextjs.Route.Route) = Nextjs.Route.Index

  let (page :: Nextjs.Lib.Page.Page) = Nextjs.RouteToPage.routeToPage route

  let (env :: Env) =
        { navigate: Nextjs.Navigate.Mobile.navigate newRouteEventIO
        , link: Nextjs.Link.Mobile.component
        }

  onDeviceReady document $ Effect.Aff.launchAff_ do
    (pageSpecWithInputBoxed :: Nextjs.Lib.Page.PageSpecWithInputBoxed) <-
      Nextjs.Lib.Page.pageToPageSpecWithInputBoxed page >>=
      (Nextjs.Lib.Api.throwApiError) \/ pure

    let initialState =
          { htmlContextInfo:
            { window
            , document
            , body
            , head
            }
          , currentPageInfo:
            { pageSpecWithInputBoxed
            , route
            }
          }

    let component = H.hoist (runAppM env) Nextjs.Router.Mobile.component

    rootElement <- selectElementRequired (Web.DOM.ParentNode.QuerySelector "#root") -- selectElement instead of awaitElement because there is no need to wait for window to load

    halogenIO <- Halogen.VDom.Driver.runUI component initialState rootElement

    void $ liftEffect $ FRP.Event.subscribe newRouteEventIO.event \newRoute -> Nextjs.Router.Shared.callNavigateQuery halogenIO newRoute

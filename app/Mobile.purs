module Nextjs.Mobile where

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
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Lib.Utils (findJsonFromScriptElement, getPathWithoutOrigin)
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.RouteToPage (routeToPage) as Nextjs.RouteToPage
import Nextjs.Router.Mobile as Nextjs.Router
import Nextjs.WebShared (getHtmlEntities)
import Protolude (Aff, Effect, Maybe(..), Unit, bind, error, launchAff_, liftEffect, maybe, pure, throwError, void, when, ($), (/=), (<$>), (<<<), (>>=), (\/))
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
onDeviceReady document callback = addEventListener
  Cordova.deviceready
  (eventListener \_ -> callback)
  false
  (Web.HTML.HTMLDocument.toEventTarget document)

main :: Effect Unit
main = do
  { window, document, body, head } <- getHtmlEntities

  onDeviceReady $ Effect.Aff.launchAff_ do
    -- first we'll get the route the user landed on
    let (route :: Nextjs.Route.Route) = Nextjs.Route.Index

    let (page :: Nextjs.Lib.Page.Page) = Nextjs.RouteToPage.routeToPage route

    (pageSpecWithInputBoxed :: Nextjs.Lib.Page.PageSpecWithInputBoxed) <-
      Nextjs.Lib.Page.pageToPageSpecWithInputBoxed page >>=
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

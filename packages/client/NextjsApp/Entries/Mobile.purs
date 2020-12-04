module NextjsApp.Entries.Mobile where

import Protolude
import Cordova.EventTypes as Cordova
import Effect.Aff as Effect.Aff
import FRP.Event as FRP.Event
import Halogen as H
import Halogen.VDom.Driver as Halogen.VDom.Driver
import NextjsApp.AppM (Env, runAppM)
import Nextjs.Page as Nextjs.Page
import Nextjs.Utils (getHtmlEntities, selectElementRequired)
import NextjsApp.Link.Mobile as NextjsApp.Link.Mobile
import NextjsApp.Navigate.Mobile as NextjsApp.Navigate.Mobile
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.RouteToPageNonClient as NextjsApp.RouteToPageNonClient
import NextjsApp.Router.Mobile as NextjsApp.Router.Mobile
import NextjsApp.Router.Shared as NextjsApp.Router.Shared
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.Event.Event (EventType)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument

onDocumentEvent ::
  forall m e.
  EventType ->
  Web.HTML.HTMLDocument ->
  Effect Unit ->
  Effect Unit
onDocumentEvent eventType document callback = do
  eventListener' <- eventListener \_ -> callback
  addEventListener eventType eventListener' false (Web.HTML.HTMLDocument.toEventTarget document)

main :: Effect Unit
main = do
  { window, document, body, head } <- getHtmlEntities
  (newRouteEventIO :: FRP.Event.EventIO NextjsApp.Route.Route) <- FRP.Event.create
  -- first we'll get the route the user landed on
  let
    (route :: NextjsApp.Route.Route) = NextjsApp.Route.Index
  let
    (page :: Nextjs.Page.Page) = NextjsApp.Route.lookupFromRouteIdMapping route NextjsApp.RouteToPageNonClient.routeIdMapping
  let
    (env :: Env) =
      { navigate: NextjsApp.Navigate.Mobile.navigate newRouteEventIO
      , linkHandleActions: NextjsApp.Link.Mobile.mkLinkHandleActions
      }
  onDocumentEvent Cordova.deviceready document $ Effect.Aff.launchAff_ do
    sessionHeader <- liftEffect NextjsApp.Router.Mobile.getMobileSessionHeaderFromSecureStorage

    Nextjs.Page.pageToPageSpecWithInputBoxed_request (Nextjs.Page.PageData_DynamicRequestOptions__Mobile { sessionHeader }) page
      >>= case _ of
        Nextjs.Page.PageToPageSpecWithInputBoxed_Response__Error str -> H.liftAff $ throwError $ error $ "PageToPageSpecWithInputBoxed_Response__Error (TODO: render error page): " <> str
        Nextjs.Page.PageToPageSpecWithInputBoxed_Response__Redirect { redirectToLocation } -> H.liftAff $ throwError $ error $ "PageToPageSpecWithInputBoxed_Response__Redirect (TODO: render error page): " <> redirectToLocation
        Nextjs.Page.PageToPageSpecWithInputBoxed_Response__Success pageSpecWithInputBoxed -> do
          let
            initialState =
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

            component = H.hoist (runAppM env) NextjsApp.Router.Mobile.component
          rootElement <- selectElementRequired (Web.DOM.ParentNode.QuerySelector "#root") -- selectElement instead of awaitElement because there is no need to wait for window to load
          halogenIO <- Halogen.VDom.Driver.runUI component initialState rootElement
          void $ liftEffect $ FRP.Event.subscribe newRouteEventIO.event \newRoute -> NextjsApp.Router.Shared.callNavigateQuery halogenIO newRoute
          void $ liftEffect $ onDocumentEvent Cordova.backbutton document (NextjsApp.Router.Shared.callNavigateQuery halogenIO NextjsApp.Route.Index)

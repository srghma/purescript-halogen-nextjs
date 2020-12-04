module NextjsApp.Router.Mobile where

import Protolude

import Effect.Exception.Unsafe (unsafeThrowException)
import Halogen as H
import Nextjs.Page as Nextjs.Page
import NextjsApp.AppM (AppM)
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.RouteToPageNonClient as NextjsApp.RouteToPageNonClient
import NextjsApp.Router.Shared (ChildSlots, MobileState, Query(..), renderPage)

component :: H.Component Query MobileState Void AppM
component =
  H.mkComponent
    { initialState: identity
    , render: \{ currentPageInfo } -> renderPage currentPageInfo
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleQuery = handleQuery
            }
    }

handleQuery :: forall next action. Query next -> H.HalogenM MobileState action ChildSlots Void AppM (Maybe next)
handleQuery = case _ of
  Navigate destRoute a -> do
    currentState <- H.get
    -- don't re-render unnecessarily if the route is unchanged
    when (currentState.currentPageInfo.route /= destRoute) (mobileLoadAndPutNewPage currentState destRoute)
    pure (Just a)

getMobileSessionHeaderFromSecureStorage :: Effect (Maybe (Tuple String String))
getMobileSessionHeaderFromSecureStorage = throwError $ error "TODO"

mobileLoadAndPutNewPage :: forall action. MobileState -> NextjsApp.Route.Route -> H.HalogenM MobileState action ChildSlots Void AppM Unit
mobileLoadAndPutNewPage currentState destRoute = do
  sessionHeader <- H.liftEffect getMobileSessionHeaderFromSecureStorage

  ( H.liftAff
    $ Nextjs.Page.pageToPageSpecWithInputBoxed_request
      ( Nextjs.Page.PageData_DynamicRequestOptions__Mobile { sessionHeader })
      ( NextjsApp.Route.lookupFromRouteIdMapping
        destRoute
        NextjsApp.RouteToPageNonClient.routeIdMapping
      )
  )
    >>= case _ of
        Nextjs.Page.PageToPageSpecWithInputBoxed_Response__Error str -> H.liftAff $ throwError $ error $ "PageToPageSpecWithInputBoxed_Response__Error (TODO: render error page): " <> str
        Nextjs.Page.PageToPageSpecWithInputBoxed_Response__Redirect { redirectToLocation } -> H.liftAff $ throwError $ error $ "PageToPageSpecWithInputBoxed_Response__Redirect (TODO: render error page): " <> redirectToLocation
        Nextjs.Page.PageToPageSpecWithInputBoxed_Response__Success pageSpecWithInputBoxed ->
          H.put
            $ currentState
                { currentPageInfo =
                  { route: destRoute
                  , pageSpecWithInputBoxed
                  }
                }

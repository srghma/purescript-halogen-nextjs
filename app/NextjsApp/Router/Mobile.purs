module NextjsApp.Router.Mobile where

import Protolude
import Halogen as H
import Nextjs.Page as Nextjs.Page
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.AppM (AppM)
import Nextjs.Api as Nextjs.Api
import NextjsApp.Router.Shared (ChildSlots, MobileState, Query(..), renderPage)
import NextjsApp.RouteToPageNonClient as NextjsApp.RouteToPageNonClient

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

mobileLoadAndPutNewPage :: forall action. MobileState -> NextjsApp.Route.Route -> H.HalogenM MobileState action ChildSlots Void AppM Unit
mobileLoadAndPutNewPage currentState destRoute = do
  let
    page = NextjsApp.Route.lookupFromRouteIdMapping destRoute NextjsApp.RouteToPageNonClient.routeIdMapping
  (H.liftAff $ Nextjs.Page.pageToPageSpecWithInputBoxed page)
    >>= case _ of
        Left error -> H.liftAff $ Nextjs.Api.throwApiError error -- TODO: show an error as alert
        Right pageSpecWithInputBoxed -> do
          H.put
            $ currentState
                { currentPageInfo =
                  { route: destRoute
                  , pageSpecWithInputBoxed
                  }
                }

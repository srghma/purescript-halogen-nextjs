module Nextjs.Router.Mobile where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.AppM (AppM)
import Nextjs.Lib.Api as Nextjs.Lib.Api
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Web.HTML as Web.HTML
import Nextjs.Router.Shared
import Nextjs.RouteToPage

component
  :: H.Component Query MobileState Void AppM
component = H.mkComponent
  { initialState: identity
  , render: \{ currentPageInfo } -> renderPage currentPageInfo
  , eval: H.mkEval $ H.defaultEval
  }

handleQuery :: forall next action. Query next -> H.HalogenM MobileState action ChildSlots Void AppM (Maybe next)
handleQuery = case _ of
  Navigate destRoute a -> do
    currentState <- H.get
    -- don't re-render unnecessarily if the route is unchanged
    when (currentState.currentPageInfo.route /= destRoute) (mobileLoadAndPutNewPage currentState destRoute)
    pure (Just a)

mobileLoadAndPutNewPage :: forall action. MobileState -> Nextjs.Route.Route -> H.HalogenM MobileState action ChildSlots Void AppM Unit
mobileLoadAndPutNewPage currentState destRoute = do
  let page = routeToPage destRoute
  (H.liftAff $ Nextjs.Lib.Page.pageToPageSpecWithInputBoxed page) >>=
    case _ of
      Left error -> H.liftAff $ Nextjs.Lib.Api.throwApiError error -- TODO: show an error as alert
      Right pageSpecWithInputBoxed -> do
        H.put $ currentState
          { currentPageInfo =
            { route: destRoute
            , pageSpecWithInputBoxed
            }
          }

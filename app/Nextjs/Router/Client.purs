module Nextjs.Router.Client where

import Protolude (Either(..), Maybe(..), Unit, Void, bind, discard, identity, pure, traceM, when, ($), (/=), (>>=))

import Halogen as H
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.AppM (AppM)
import Nextjs.Lib.Api as Nextjs.Lib.Api
import Nextjs.Router.Shared

component
  :: H.Component Query ClientState Void AppM
component = H.mkComponent
  { initialState: identity
  , render: maybeRenderPage
  , eval: H.mkEval $ H.defaultEval
      { handleQuery = handleQuery
      }
  }

handleQuery :: forall next action. Query next -> H.HalogenM ClientState action ChildSlots Void AppM (Maybe next)
handleQuery = case _ of
  Navigate destRoute a -> do
    currentState <- H.get

    -- | traceM { currentState, destRoute }

    -- don't re-render unnecessarily if the route is unchanged
    case currentState.currentPageInfo of
      Just { route } -> when (route /= destRoute) (clientLoadAndPutNewPage currentState destRoute)
      Nothing -> clientLoadAndPutNewPage currentState destRoute
    pure (Just a)

clientLoadAndPutNewPage :: forall action. ClientState -> Nextjs.Route.Route -> H.HalogenM ClientState action ChildSlots Void AppM Unit
clientLoadAndPutNewPage currentState destRoute = do
  -- | traceM { message: "clientLoadAndPutNewPage", currentState, destRoute }

  page <- H.liftAff $ Nextjs.PageLoader.loadPage
    currentState.clientPagesManifest
    currentState.htmlContextInfo.document
    currentState.htmlContextInfo.body
    currentState.htmlContextInfo.head
    currentState.pageRegisteredEvent
    destRoute

  -- | traceM { message: "clientLoadAndPutNewPage pageloaded", currentState, destRoute }

  (H.liftAff $ Nextjs.Lib.Page.pageToPageSpecWithInputBoxed page) >>=
    case _ of
      Left error -> H.liftAff $ Nextjs.Lib.Api.throwApiError error -- TODO: show an error as alert
      Right pageSpecWithInputBoxed -> do
        -- | traceM { message: "clientLoadAndPutNewPage put", pageSpecWithInputBoxed }

        H.put $ currentState
          { currentPageInfo = Just
            { route: destRoute
            , pageSpecWithInputBoxed
            }
          }

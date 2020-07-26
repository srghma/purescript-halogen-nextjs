module Nextjs.Router where

import Protolude (Const, Either(..), Maybe(..), SProxy(..), Void, absurd, bind, discard, identity, pure, spy, when, ($), (/=), (>>=))

import Halogen as H
import Halogen.HTML as HH
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.AppM (AppM)
import Nextjs.Lib.Api as Nextjs.Lib.Api
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Web.HTML as Web.HTML
import Type.Row (type (+))

type CurrentPageInfo = Maybe
  { pageSpecWithInputBoxed :: Nextjs.Lib.Page.PageSpecWithInputBoxed
  , route :: Nextjs.Route.Route
  }

type StateClientAndServerRow r =
  ( currentPageInfo :: CurrentPageInfo
  | r
  )

type StateOnlyClient r =
  ( pageRegisteredEvent :: Nextjs.PageLoader.PageRegisteredEvent
  , clientPagesManifest :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  , document :: Web.HTML.HTMLDocument
  , body :: Web.HTML.HTMLElement
  , head :: Web.HTML.HTMLHeadElement
  | r
  )

type ServerState r = { | StateClientAndServerRow + r }
type ClientState = { | StateOnlyClient + StateClientAndServerRow + () }

data Query a
  = Navigate Nextjs.Route.Route a

type ChildSlots =
  ( page :: H.Slot (Const Void) Void Nextjs.Route.Route -- the index here (Nextjs.Route.Route) is very important, the page wont just update if we replace it with Unit
  )

render :: forall action r . ServerState r -> H.ComponentHTML action ChildSlots AppM
render { currentPageInfo } =
  case currentPageInfo of
       Nothing -> HH.div_ [ HH.text "Oh no! That page wasn't found." ]
       Just { route, pageSpecWithInputBoxed } ->
          Nextjs.Lib.Page.unPageSpecWithInputBoxed
            (\pageSpecWithInput ->
              HH.div_
                [ HH.text pageSpecWithInput.title
                , HH.slot (SProxy :: SProxy "page") route pageSpecWithInput.component pageSpecWithInput.input absurd
                ]
            )
            (spy "rendering pageSpecWithInputBoxed" pageSpecWithInputBoxed)

serverComponent
  :: forall r
   . H.Component Query (ServerState r) Void AppM
serverComponent = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval $ H.defaultEval
  }

clientComponent
  :: H.Component Query ClientState Void AppM
clientComponent = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval $ H.defaultEval
      { handleQuery = handleQuery
      }
  }

handleQuery :: forall next action. Query next -> H.HalogenM ClientState action ChildSlots Void AppM (Maybe next)
handleQuery = case _ of
  Navigate destRoute a -> do
    currentState <- H.get
    -- don't re-render unnecessarily if the route is unchanged
    case currentState.currentPageInfo of
      Just { route } -> do
        when (route /= destRoute) (loadAndPutNewPage currentState destRoute)
      Nothing -> loadAndPutNewPage currentState destRoute
    pure (Just a)
  where
    loadAndPutNewPage currentState destRoute = do
      page <- H.liftAff $ Nextjs.PageLoader.loadPage
        currentState.clientPagesManifest
        currentState.document
        currentState.body
        currentState.head
        currentState.pageRegisteredEvent
        destRoute
      (H.liftAff $ Nextjs.Lib.Page.pageToPageSpecWithInputBoxed page) >>=
        case _ of
          Left error -> H.liftAff $ Nextjs.Lib.Api.throwApiError error
          Right pageSpecWithInputBoxed -> do
            H.put $ currentState
              { currentPageInfo = Just
                { route: destRoute
                , pageSpecWithInputBoxed
                }
              }

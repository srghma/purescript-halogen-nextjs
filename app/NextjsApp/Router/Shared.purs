module NextjsApp.Router.Shared where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import Nextjs.Page as Nextjs.Page
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.PageLoader as NextjsApp.PageLoader
import NextjsApp.Route as NextjsApp.Route
import Web.HTML as Web.HTML

type CurrentPageInfo =
  { pageSpecWithInputBoxed :: Nextjs.Page.PageSpecWithInputBoxed
  , route :: NextjsApp.Route.Route
  }

type HtmlContextInfo =
  { window :: Web.HTML.Window
  , document :: Web.HTML.HTMLDocument
  , body :: Web.HTML.HTMLElement
  , head :: Web.HTML.HTMLHeadElement
  }

----------------------

type ServerState =
  { currentPageInfo :: Maybe CurrentPageInfo
  }

type ClientState =
  { currentPageInfo :: Maybe CurrentPageInfo
  , htmlContextInfo :: HtmlContextInfo
  , pageRegisteredEvent :: NextjsApp.PageLoader.PageRegisteredEvent
  , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
  }

type MobileState =
  { currentPageInfo :: CurrentPageInfo
  , htmlContextInfo :: HtmlContextInfo
  }

data Query a
  = Navigate NextjsApp.Route.Route a

type ChildSlots =
  ( page :: H.Slot (Const Void) Void NextjsApp.Route.Route -- the index here (NextjsApp.Route.Route) is very important, the page won't just update if we replace it with Unit
  )

renderPage :: forall action . CurrentPageInfo -> H.ComponentHTML action ChildSlots AppM
renderPage { route, pageSpecWithInputBoxed } = Nextjs.Page.unPageSpecWithInputBoxed
  (\pageSpecWithInput -> HH.slot (SProxy :: SProxy "page") route pageSpecWithInput.component pageSpecWithInput.input absurd)
  pageSpecWithInputBoxed

maybeRenderPage :: forall action r . { currentPageInfo :: Maybe CurrentPageInfo | r } -> H.ComponentHTML action ChildSlots AppM
maybeRenderPage { currentPageInfo } =
  case currentPageInfo of
       Nothing -> HH.div_ [ HH.text "Oh no! That page wasn't found." ]
       Just currentPageInfo' -> renderPage currentPageInfo'

callNavigateQueryIfNew :: forall output . H.HalogenIO Query output Aff -> Maybe NextjsApp.Route.Route -> NextjsApp.Route.Route -> Effect Unit
callNavigateQueryIfNew halogenIO oldRoute newRoute = when (oldRoute /= Just newRoute) (callNavigateQuery halogenIO newRoute)

callNavigateQuery :: forall output . H.HalogenIO Query output Aff -> NextjsApp.Route.Route -> Effect Unit
callNavigateQuery halogenIO newRoute = launchAff_ $ halogenIO.query $ H.mkTell $ Navigate newRoute

module Nextjs.Router.Shared where

import Protolude

import Data.Argonaut.Core as ArgonautCore
import Halogen as H
import Halogen.HTML as HH
import Nextjs.AppM (AppM(..))
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML as Web.HTML

type CurrentPageInfo =
  { pageSpecWithInputBoxed :: Nextjs.Lib.Page.PageSpecWithInputBoxed
  , route :: Nextjs.Route.Route
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
  , pageRegisteredEvent :: Nextjs.PageLoader.PageRegisteredEvent
  , clientPagesManifest :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  }

type MobileState =
  { currentPageInfo :: CurrentPageInfo
  , htmlContextInfo :: HtmlContextInfo
  }

data Query a
  = Navigate Nextjs.Route.Route a

type ChildSlots =
  ( page :: H.Slot (Const Void) Void Nextjs.Route.Route -- the index here (Nextjs.Route.Route) is very important, the page wont just update if we replace it with Unit
  )

renderPage :: forall action . CurrentPageInfo -> H.ComponentHTML action ChildSlots AppM
renderPage { route, pageSpecWithInputBoxed } = Nextjs.Lib.Page.unPageSpecWithInputBoxed
  (\pageSpecWithInput ->
    HH.div_
      [ HH.text pageSpecWithInput.title
      , HH.slot (SProxy :: SProxy "page") route pageSpecWithInput.component pageSpecWithInput.input absurd
      ]
  )
  pageSpecWithInputBoxed

render :: forall action r . { currentPageInfo :: Maybe CurrentPageInfo | r } -> H.ComponentHTML action ChildSlots AppM
render { currentPageInfo } =
  case currentPageInfo of
       Nothing -> HH.div_ [ HH.text "Oh no! That page wasn't found." ]
       Just currentPageInfo' -> renderPage currentPageInfo'

callNavigateQueryIfNew :: forall output . H.HalogenIO Query output Aff -> Maybe Nextjs.Route.Route -> Nextjs.Route.Route -> Effect Unit
callNavigateQueryIfNew halogenIO oldRoute newRoute = when (oldRoute /= Just newRoute) do
  launchAff_ $ halogenIO.query $ H.mkTell $ Navigate newRoute

callNavigateQuery :: forall output . H.HalogenIO Query output Aff -> Nextjs.Route.Route -> Effect Unit
callNavigateQuery halogenIO newRoute = do
  -- | traceM (ArgonautCore.stringifyWithSpace 2 (unsafeCoerce { message: "newRoute", newRoute: show newRoute }))
  launchAff_ $ halogenIO.query $ H.mkTell $ Navigate newRoute

module Nextjs.Router.Server where

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

serverComponent
  :: forall r
   . H.Component Query { currentPageInfo :: Maybe CurrentPageInfo | r } Void AppM
serverComponent = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval $ H.defaultEval
  }

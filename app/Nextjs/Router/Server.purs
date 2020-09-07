module Nextjs.Router.Server where

import Protolude (Maybe, Void, identity, ($))

import Halogen as H
import Nextjs.AppM (AppM)
import Nextjs.Router.Shared

serverComponent
  :: forall r
   . H.Component Query { currentPageInfo :: Maybe CurrentPageInfo | r } Void AppM
serverComponent = H.mkComponent
  { initialState: identity
  , render: maybeRenderPage
  , eval: H.mkEval $ H.defaultEval
  }

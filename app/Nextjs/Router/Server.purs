module Nextjs.Router.Server where

import Protolude (Maybe, Void, identity, ($))

import Halogen as H
import Nextjs.AppM (AppM)
import Nextjs.Router.Shared (CurrentPageInfo, Query, render)

serverComponent
  :: forall r
   . H.Component Query { currentPageInfo :: Maybe CurrentPageInfo | r } Void AppM
serverComponent = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval $ H.defaultEval
  }

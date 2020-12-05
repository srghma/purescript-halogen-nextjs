module NextjsApp.Pages.Login (page) where

import Protolude
import NextjsApp.PageImplementations.Login as NextjsApp.PageImplementations.Login
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Login.component
  , title: "Login"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

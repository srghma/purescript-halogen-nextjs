module NextjsApp.Pages.Register (page) where

import Protolude
import NextjsApp.PageImplementations.Register as NextjsApp.PageImplementations.Register
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Register.component
  , title: "Register"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

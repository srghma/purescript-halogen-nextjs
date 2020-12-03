module NextjsApp.Pages.Login (page) where

import Protolude
import NextjsApp.PageImplementations.Login as NextjsApp.PageImplementations.Login
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Login.component
  , title: "Login"
  }

page :: Page
page = mkPage pageSpec

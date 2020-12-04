module NextjsApp.Pages.Register (page) where

import Protolude
import NextjsApp.PageImplementations.Register as NextjsApp.PageImplementations.Register
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Register.component
  , title: "Register"
  }

page :: Page
page = mkPage pageSpec

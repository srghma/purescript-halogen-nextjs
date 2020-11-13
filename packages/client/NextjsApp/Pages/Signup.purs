module NextjsApp.Pages.Signup (page) where

import Protolude
import NextjsApp.PageImplementations.Signup as NextjsApp.PageImplementations.Signup
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: NextjsApp.PageImplementations.Signup.component
  , title: "Signup"
  }

page :: Page
page = mkPage pageSpec

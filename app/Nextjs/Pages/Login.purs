module Nextjs.Pages.Login (page) where

import Protolude (Unit, unit)
import Nextjs.PageImplementations.Login as Nextjs.PageImplementations.Login
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: Nextjs.PageImplementations.Login.component
  , title: "Login"
  }

page :: Page
page = mkPage pageSpec

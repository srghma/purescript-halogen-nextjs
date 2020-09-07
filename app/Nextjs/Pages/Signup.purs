module Nextjs.Pages.Signup (page) where

import Protolude (Unit, unit)
import Nextjs.PageImplementations.Signup as Nextjs.PageImplementations.Signup
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: Nextjs.PageImplementations.Signup.component
  , title: "Signup"
  }

page :: Page
page = mkPage pageSpec

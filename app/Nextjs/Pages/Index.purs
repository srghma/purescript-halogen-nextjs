module Nextjs.Pages.Index (page) where

import Protolude (Unit, unit)
import Lib.Pages.Index.Default as Lib.Pages.Index.Default
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: Lib.Pages.Index.Default.component
  , title: "Index"
  }

page :: Page
page = mkPage pageSpec

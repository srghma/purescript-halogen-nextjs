module Nextjs.Pages.Index (page) where

import Protolude (Unit, unit)
import Nextjs.PageImplementations.Index as Nextjs.PageImplementations.Index
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: Nextjs.PageImplementations.Index.component
  , title: "Index"
  }

page :: Page
page = mkPage pageSpec

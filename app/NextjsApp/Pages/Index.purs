module NextjsApp.Pages.Index (page) where

import Protolude
import NextjsApp.PageImplementations.Index as NextjsApp.PageImplementations.Index
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: NextjsApp.PageImplementations.Index.component
  , title: "Index"
  }

page :: Page
page = mkPage pageSpec

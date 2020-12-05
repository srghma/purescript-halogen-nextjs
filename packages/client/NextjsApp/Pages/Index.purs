module NextjsApp.Pages.Index (page) where

import Protolude
import NextjsApp.PageImplementations.Index as NextjsApp.PageImplementations.Index
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Index.component
  , title: "Index"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

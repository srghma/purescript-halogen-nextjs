module Nextjs.Pages.Index (page) where

import Protolude
import Lib.Pages.Index.Default as Lib.Pages.Index.Default
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: Lib.Pages.Index.Default.component
  , title: "Index"
  }

page :: Page
page = mkPage pageSpec

module Nextjs.Pages.Secret (page) where

import Protolude (Unit, unit)
import Nextjs.PageImplementations.Secret as Nextjs.PageImplementations.Secret
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: Nextjs.PageImplementations.Secret.component
  , title: "Secret"
  }

page :: Page
page = mkPage pageSpec

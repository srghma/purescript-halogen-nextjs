module NextjsApp.Pages.Secret (page) where

import Protolude
import NextjsApp.PageImplementations.Secret as NextjsApp.PageImplementations.Secret
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: NextjsApp.PageImplementations.Secret.component
  , title: "Secret"
  }

page :: Page
page = mkPage pageSpec

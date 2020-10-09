module NextjsApp.Pages.Examples.Basic (page) where

import Protolude
import Example.Basic.Button as Example.Basic.Button
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Basic.Button.component
  , title: "Halogen Example - Basic button"
  }

page :: Page
page = mkPage pageSpec

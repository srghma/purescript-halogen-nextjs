module Nextjs.Pages.Basic (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Basic.Button as Example.Basic.Button
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Basic.Button.component
  , title: "Halogen Example - Basic button"
  }

page :: Page
page = mkPage pageSpec

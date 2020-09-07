module Nextjs.Pages.Examples.HigherOrderComponents (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.HOC.Harness as Example.HOC.Harness
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.HOC.Harness.component
  , title: "Halogen Example - HigherOrderComponents button"
  }

page :: Page
page = mkPage pageSpec

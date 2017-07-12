module Nextjs.Pages.HigherOrderComponents (page) where

import Protolude
import Example.HOC.Harness as Example.HOC.Harness
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.HOC.Harness.component
  , title: "Halogen Example - HigherOrderComponents button"
  }

page :: Page
page = mkPage pageSpec

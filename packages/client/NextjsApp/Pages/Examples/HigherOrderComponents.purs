module NextjsApp.Pages.Examples.HigherOrderComponents (page) where

import Protolude
import Example.HOC.Harness as Example.HOC.Harness
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.HOC.Harness.component
  , title: "Halogen Example - HigherOrderComponents button"
  }

page :: Page
page = mkPage pageSpec

module NextjsApp.Pages.Examples.HigherOrderComponents (page) where

import Protolude
import Example.HOC.Harness as Example.HOC.Harness
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.HOC.Harness.component
  , title: "Halogen Example - HigherOrderComponents button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

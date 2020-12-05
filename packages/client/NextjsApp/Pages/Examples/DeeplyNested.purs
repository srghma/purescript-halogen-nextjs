module NextjsApp.Pages.Examples.DeeplyNested (page) where

import Protolude
import Example.DeeplyNested.A as Example.DeeplyNested.A
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.DeeplyNested.A.component
  , title: "Halogen Example - DeeplyNested button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

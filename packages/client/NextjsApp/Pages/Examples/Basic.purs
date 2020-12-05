module NextjsApp.Pages.Examples.Basic (page) where

import Protolude
import Example.Basic.Button as Example.Basic.Button
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Basic.Button.component
  , title: "Halogen Example - Basic button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

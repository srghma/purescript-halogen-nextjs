module NextjsApp.Pages.Examples.ComponentsInputs (page) where

import Protolude
import Example.Components.Inputs.Container as Container
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - Components with inputs example"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

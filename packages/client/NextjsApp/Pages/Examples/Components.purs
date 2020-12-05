module NextjsApp.Pages.Examples.Components (page) where

import Protolude
import Example.Components.Container as Example.Components.Container
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Components.Container.component
  , title: "Halogen Example - Components button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

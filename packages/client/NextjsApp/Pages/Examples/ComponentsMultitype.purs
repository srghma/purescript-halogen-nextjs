module NextjsApp.Pages.Examples.ComponentsMultitype (page) where

import Protolude
import Example.Components.Multitype.Container as Container
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - components multitype button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

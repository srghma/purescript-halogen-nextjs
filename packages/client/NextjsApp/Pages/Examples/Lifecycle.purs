module NextjsApp.Pages.Examples.Lifecycle (page) where

import Protolude
import Example.Lifecycle.Main as Example.Lifecycle.Main
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Lifecycle.Main.ui
  , title: "Halogen Example - Lifecycle button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

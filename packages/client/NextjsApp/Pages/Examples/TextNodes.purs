module NextjsApp.Pages.Examples.TextNodes (page) where

import Protolude
import Example.TextNodes.Main as Example.TextNodes.Main
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.TextNodes.Main.component
  , title: "Halogen Example - Text nodes"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

module NextjsApp.Pages.Examples.Ace (page) where

import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Protolude
import Halogen as H
import Example.Ace.Container as Example.Ace.Container

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Ace.Container.component
  , title: "Halogen Example - Ace button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

module NextjsApp.Pages.Examples.Lifecycle (page) where

import Protolude
import Example.Lifecycle.Main as Example.Lifecycle.Main
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Lifecycle.Main.ui
  , title: "Halogen Example - Lifecycle button"
  }

page :: Page
page = mkPage pageSpec

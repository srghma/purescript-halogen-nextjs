module NextjsApp.Pages.Examples.KeyboardInput (page) where

import Protolude
import Example.KeyboardInput.Main as Example.KeyboardInput.Main
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.KeyboardInput.Main.ui
  , title: "Halogen Example - KeyboardInput button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

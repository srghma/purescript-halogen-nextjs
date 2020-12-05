module NextjsApp.Pages.Examples.Lazy (page) where

import Protolude
import Example.Lazy.Main as Example.Lazy.Main
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Lazy.Main.component
  , title: "Halogen Example - lazy"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

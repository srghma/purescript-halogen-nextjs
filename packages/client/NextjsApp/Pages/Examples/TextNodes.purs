module NextjsApp.Pages.Examples.TextNodes (page) where

import Protolude
import Example.TextNodes.Main as Example.TextNodes.Main
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.TextNodes.Main.component
  , title: "Halogen Example - Text nodes"
  }

page :: Page
page = mkPage pageSpec

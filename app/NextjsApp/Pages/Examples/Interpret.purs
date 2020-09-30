module NextjsApp.Pages.Examples.Interpret (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Interpret.Main as Example.Interpret.Main
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Interpret.Main.ui'
  , title: "Halogen Example - Interpret button"
  }

page :: Page
page = mkPage pageSpec

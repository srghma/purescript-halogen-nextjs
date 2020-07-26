module Nextjs.Pages.Lifecycle (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Lifecycle.Main as Example.Lifecycle.Main
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Lifecycle.Main.ui
  , title: "Halogen Example - Lifecycle button"
  }

page :: Page
page = mkPage pageSpec

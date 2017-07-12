module Nextjs.Pages.Lifecycle (page) where

import Protolude
import Example.Lifecycle.Main as Example.Lifecycle.Main
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Lifecycle.Main.ui
  , title: "Halogen Example - Lifecycle button"
  }

page :: Page
page = mkPage pageSpec

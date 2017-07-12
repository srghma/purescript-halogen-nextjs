module Nextjs.Pages.Interpret (page) where

import Protolude
import Example.Interpret.Main as Example.Interpret.Main
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Interpret.Main.ui'
  , title: "Halogen Example - Interpret button"
  }

page :: Page
page = mkPage pageSpec

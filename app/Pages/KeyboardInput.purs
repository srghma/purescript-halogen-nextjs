module Nextjs.Pages.KeyboardInput (page) where

import Protolude
import Example.KeyboardInput.Main as Example.KeyboardInput.Main
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.KeyboardInput.Main.ui
  , title: "Halogen Example - KeyboardInput button"
  }

page :: Page
page = mkPage pageSpec

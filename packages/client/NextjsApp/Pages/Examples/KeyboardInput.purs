module NextjsApp.Pages.Examples.KeyboardInput (page) where

import Protolude
import Example.KeyboardInput.Main as Example.KeyboardInput.Main
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.KeyboardInput.Main.ui
  , title: "Halogen Example - KeyboardInput button"
  }

page :: Page
page = mkPage pageSpec

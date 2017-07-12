module Nextjs.Pages.TextNodes (page) where

import Protolude
import Example.TextNodes.Main as Example.TextNodes.Main
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.TextNodes.Main.component
  , title: "Halogen Example - Text nodes"
  }

page :: Page
page = mkPage pageSpec

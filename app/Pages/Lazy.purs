module Nextjs.Pages.Lazy (page) where

import Protolude
import Example.Lazy.Main as Example.Lazy.Main
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Lazy.Main.component
  , title: "Halogen Example - lazy"
  }

page :: Page
page = mkPage pageSpec

module Nextjs.Pages.Basic (page) where

import Protolude
import Example.Basic.Button as Example.Basic.Button
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Basic.Button.component
  , title: "Halogen Example - Basic button"
  }

page :: Page
page = mkPage pageSpec

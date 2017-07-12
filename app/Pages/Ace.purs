module Nextjs.Pages.Ace (page) where

import Nextjs.Lib.Page
import Protolude
import Halogen as H

import Example.Ace.Container as Example.Ace.Container
import Halogen.HTML as Halogen.HTML

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Ace.Container.component
  , title: "Halogen Example - Ace button"
  }

page :: Page
page = mkPage pageSpec

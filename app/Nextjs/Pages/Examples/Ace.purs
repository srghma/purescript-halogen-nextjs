module Nextjs.Pages.Examples.Ace (page) where

import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Protolude (Unit, liftAff, unit, ($))
import Halogen as H

import Example.Ace.Container as Example.Ace.Container

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Ace.Container.component
  , title: "Halogen Example - Ace button"
  }

page :: Page
page = mkPage pageSpec

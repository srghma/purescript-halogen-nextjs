module NextjsApp.Pages.Examples.Ace (page) where

import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Protolude
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

module Nextjs.Pages.EffectsAffAjax (page) where

import Protolude
import Example.Effects.Aff.Ajax.Component as Example.Effects.Aff.Ajax.Component
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Effects.Aff.Ajax.Component.component
  , title: "Halogen Example - EffectsAffAjax button"
  }

page :: Page
page = mkPage pageSpec

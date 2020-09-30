module NextjsApp.Pages.Examples.EffectsAffAjax (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Effects.Aff.Ajax.Component as Example.Effects.Aff.Ajax.Component
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Effects.Aff.Ajax.Component.component
  , title: "Halogen Example - EffectsAffAjax button"
  }

page :: Page
page = mkPage pageSpec

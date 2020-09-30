module NextjsApp.Pages.Examples.EffectsEffectRandom (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Effects.Effect.Random.Component as Example.Effects.Effect.Random.Component
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Effects.Effect.Random.Component.component
  , title: "Halogen Example - EffectsEffectRandom button"
  }

page :: Page
page = mkPage pageSpec

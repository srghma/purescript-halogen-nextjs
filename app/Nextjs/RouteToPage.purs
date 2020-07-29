module Nextjs.RouteToPage where

import Nextjs.Pages.Index                 as Nextjs.Pages.Index
import Nextjs.Pages.Ace                   as Nextjs.Pages.Ace
import Nextjs.Pages.Basic                 as Nextjs.Pages.Basic
import Nextjs.Pages.Components            as Nextjs.Pages.Components
import Nextjs.Pages.ComponentsInputs      as Nextjs.Pages.ComponentsInputs
import Nextjs.Pages.ComponentsMultitype   as Nextjs.Pages.ComponentsMultitype
import Nextjs.Pages.EffectsAffAjax        as Nextjs.Pages.EffectsAffAjax
import Nextjs.Pages.EffectsEffectRandom   as Nextjs.Pages.EffectsEffectRandom
import Nextjs.Pages.HigherOrderComponents as Nextjs.Pages.HigherOrderComponents
import Nextjs.Pages.Interpret             as Nextjs.Pages.Interpret
import Nextjs.Pages.KeyboardInput         as Nextjs.Pages.KeyboardInput
import Nextjs.Pages.Lifecycle             as Nextjs.Pages.Lifecycle
import Nextjs.Pages.DeeplyNested          as Nextjs.Pages.DeeplyNested
import Nextjs.Pages.DynamicInput          as Nextjs.Pages.DynamicInput
import Nextjs.Pages.TextNodes             as Nextjs.Pages.TextNodes
import Nextjs.Pages.Lazy                  as Nextjs.Pages.Lazy
import Nextjs.Pages.Buttons.Buttons       as Nextjs.Pages.Buttons.Buttons
import Nextjs.Pages.Buttons.Fabs          as Nextjs.Pages.Buttons.Fabs
import Nextjs.Pages.Buttons.IconButtons   as Nextjs.Pages.Buttons.IconButtons

import Nextjs.Route    as Nextjs.Route
import Nextjs.Lib.Page as Nextjs.Lib.Page

pagesRec :: Nextjs.Route.PagesRec Nextjs.Lib.Page.Page
pagesRec =
  { "Index":                 Nextjs.Pages.Index.page
  , "Ace":                   Nextjs.Pages.Ace.page
  , "Basic":                 Nextjs.Pages.Basic.page
  , "Components":            Nextjs.Pages.Components.page
  , "ComponentsInputs":      Nextjs.Pages.ComponentsInputs.page
  , "ComponentsMultitype":   Nextjs.Pages.ComponentsMultitype.page
  , "EffectsAffAjax":        Nextjs.Pages.EffectsAffAjax.page
  , "EffectsEffectRandom":   Nextjs.Pages.EffectsEffectRandom.page
  , "HigherOrderComponents": Nextjs.Pages.HigherOrderComponents.page
  , "Interpret":             Nextjs.Pages.Interpret.page
  , "KeyboardInput":         Nextjs.Pages.KeyboardInput.page
  , "Lifecycle":             Nextjs.Pages.Lifecycle.page
  , "DeeplyNested":          Nextjs.Pages.DeeplyNested.page
  , "DynamicInput":          Nextjs.Pages.DynamicInput.page
  , "TextNodes":             Nextjs.Pages.TextNodes.page
  , "Lazy":                  Nextjs.Pages.Lazy.page
  , "Buttons":
    { "Buttons":     Nextjs.Pages.Buttons.Buttons.page
    , "Fabs":        Nextjs.Pages.Buttons.Fabs.page
    , "IconButtons": Nextjs.Pages.Buttons.IconButtons.page
    }
  }

routeToPage :: Nextjs.Route.Route -> Nextjs.Lib.Page.Page
routeToPage route = Nextjs.Route.extractFromPagesRec route pagesRec

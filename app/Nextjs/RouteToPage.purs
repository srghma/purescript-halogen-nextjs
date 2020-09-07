module Nextjs.RouteToPage where

import Nextjs.Route    as Nextjs.Route
import Nextjs.Lib.Page as Nextjs.Lib.Page

import Nextjs.Pages.Index  as Nextjs.Pages.Index
import Nextjs.Pages.Login  as Nextjs.Pages.Login
import Nextjs.Pages.Signup as Nextjs.Pages.Signup
import Nextjs.Pages.Secret as Nextjs.Pages.Secret

import Nextjs.Pages.Examples.Ace                   as Nextjs.Pages.Examples.Ace
import Nextjs.Pages.Examples.Basic                 as Nextjs.Pages.Examples.Basic
import Nextjs.Pages.Examples.Components            as Nextjs.Pages.Examples.Components
import Nextjs.Pages.Examples.ComponentsInputs      as Nextjs.Pages.Examples.ComponentsInputs
import Nextjs.Pages.Examples.ComponentsMultitype   as Nextjs.Pages.Examples.ComponentsMultitype
import Nextjs.Pages.Examples.EffectsAffAjax        as Nextjs.Pages.Examples.EffectsAffAjax
import Nextjs.Pages.Examples.EffectsEffectRandom   as Nextjs.Pages.Examples.EffectsEffectRandom
import Nextjs.Pages.Examples.HigherOrderComponents as Nextjs.Pages.Examples.HigherOrderComponents
import Nextjs.Pages.Examples.Interpret             as Nextjs.Pages.Examples.Interpret
import Nextjs.Pages.Examples.KeyboardInput         as Nextjs.Pages.Examples.KeyboardInput
import Nextjs.Pages.Examples.Lifecycle             as Nextjs.Pages.Examples.Lifecycle
import Nextjs.Pages.Examples.DeeplyNested          as Nextjs.Pages.Examples.DeeplyNested
import Nextjs.Pages.Examples.DynamicInput          as Nextjs.Pages.Examples.DynamicInput
import Nextjs.Pages.Examples.TextNodes             as Nextjs.Pages.Examples.TextNodes
import Nextjs.Pages.Examples.Lazy                  as Nextjs.Pages.Examples.Lazy

pagesRec :: Nextjs.Route.PagesRec Nextjs.Lib.Page.Page
pagesRec =
  { "Index":  Nextjs.Pages.Index.page
  , "Login":  Nextjs.Pages.Login.page
  , "Signup": Nextjs.Pages.Signup.page
  , "Secret": Nextjs.Pages.Secret.page

  , "Examples__Ace":                   Nextjs.Pages.Examples.Ace.page
  , "Examples__Basic":                 Nextjs.Pages.Examples.Basic.page
  , "Examples__Components":            Nextjs.Pages.Examples.Components.page
  , "Examples__ComponentsInputs":      Nextjs.Pages.Examples.ComponentsInputs.page
  , "Examples__ComponentsMultitype":   Nextjs.Pages.Examples.ComponentsMultitype.page
  , "Examples__EffectsAffAjax":        Nextjs.Pages.Examples.EffectsAffAjax.page
  , "Examples__EffectsEffectRandom":   Nextjs.Pages.Examples.EffectsEffectRandom.page
  , "Examples__HigherOrderComponents": Nextjs.Pages.Examples.HigherOrderComponents.page
  , "Examples__Interpret":             Nextjs.Pages.Examples.Interpret.page
  , "Examples__KeyboardInput":         Nextjs.Pages.Examples.KeyboardInput.page
  , "Examples__Lifecycle":             Nextjs.Pages.Examples.Lifecycle.page
  , "Examples__DeeplyNested":          Nextjs.Pages.Examples.DeeplyNested.page
  , "Examples__DynamicInput":          Nextjs.Pages.Examples.DynamicInput.page
  , "Examples__TextNodes":             Nextjs.Pages.Examples.TextNodes.page
  , "Examples__Lazy":                  Nextjs.Pages.Examples.Lazy.page
  }

routeToPage :: Nextjs.Route.Route -> Nextjs.Lib.Page.Page
routeToPage route = Nextjs.Route.extractFromPagesRec route pagesRec

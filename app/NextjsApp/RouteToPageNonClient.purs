module NextjsApp.RouteToPageNonClient where

import NextjsApp.Route    as NextjsApp.Route
import Nextjs.Page as Nextjs.Page

import NextjsApp.Pages.Index  as NextjsApp.Pages.Index
import NextjsApp.Pages.Login  as NextjsApp.Pages.Login
import NextjsApp.Pages.Signup as NextjsApp.Pages.Signup
import NextjsApp.Pages.Secret as NextjsApp.Pages.Secret

import NextjsApp.Pages.Examples.Ace                   as NextjsApp.Pages.Examples.Ace
import NextjsApp.Pages.Examples.Basic                 as NextjsApp.Pages.Examples.Basic
import NextjsApp.Pages.Examples.Components            as NextjsApp.Pages.Examples.Components
import NextjsApp.Pages.Examples.ComponentsInputs      as NextjsApp.Pages.Examples.ComponentsInputs
import NextjsApp.Pages.Examples.ComponentsMultitype   as NextjsApp.Pages.Examples.ComponentsMultitype
import NextjsApp.Pages.Examples.EffectsAffAjax        as NextjsApp.Pages.Examples.EffectsAffAjax
import NextjsApp.Pages.Examples.EffectsEffectRandom   as NextjsApp.Pages.Examples.EffectsEffectRandom
import NextjsApp.Pages.Examples.HigherOrderComponents as NextjsApp.Pages.Examples.HigherOrderComponents
import NextjsApp.Pages.Examples.Interpret             as NextjsApp.Pages.Examples.Interpret
import NextjsApp.Pages.Examples.KeyboardInput         as NextjsApp.Pages.Examples.KeyboardInput
import NextjsApp.Pages.Examples.Lifecycle             as NextjsApp.Pages.Examples.Lifecycle
import NextjsApp.Pages.Examples.DeeplyNested          as NextjsApp.Pages.Examples.DeeplyNested
import NextjsApp.Pages.Examples.DynamicInput          as NextjsApp.Pages.Examples.DynamicInput
import NextjsApp.Pages.Examples.TextNodes             as NextjsApp.Pages.Examples.TextNodes
import NextjsApp.Pages.Examples.Lazy                  as NextjsApp.Pages.Examples.Lazy

-- XXX: you should NOT IMPORT this module from client

pagesRec :: NextjsApp.Route.PagesRec Nextjs.Page.Page
pagesRec =
  { "Index":  NextjsApp.Pages.Index.page
  , "Login":  NextjsApp.Pages.Login.page
  , "Signup": NextjsApp.Pages.Signup.page
  , "Secret": NextjsApp.Pages.Secret.page

  -- XXX: the manifest id separator is __ !!!!
  , "Examples.Ace":                   NextjsApp.Pages.Examples.Ace.page
  , "Examples.Basic":                 NextjsApp.Pages.Examples.Basic.page
  , "Examples.Components":            NextjsApp.Pages.Examples.Components.page
  , "Examples.ComponentsInputs":      NextjsApp.Pages.Examples.ComponentsInputs.page
  , "Examples.ComponentsMultitype":   NextjsApp.Pages.Examples.ComponentsMultitype.page
  , "Examples.EffectsAffAjax":        NextjsApp.Pages.Examples.EffectsAffAjax.page
  , "Examples.EffectsEffectRandom":   NextjsApp.Pages.Examples.EffectsEffectRandom.page
  , "Examples.HigherOrderComponents": NextjsApp.Pages.Examples.HigherOrderComponents.page
  , "Examples.Interpret":             NextjsApp.Pages.Examples.Interpret.page
  , "Examples.KeyboardInput":         NextjsApp.Pages.Examples.KeyboardInput.page
  , "Examples.Lifecycle":             NextjsApp.Pages.Examples.Lifecycle.page
  , "Examples.DeeplyNested":          NextjsApp.Pages.Examples.DeeplyNested.page
  , "Examples.DynamicInput":          NextjsApp.Pages.Examples.DynamicInput.page
  , "Examples.TextNodes":             NextjsApp.Pages.Examples.TextNodes.page
  , "Examples.Lazy":                  NextjsApp.Pages.Examples.Lazy.page
  }

routeToPage :: NextjsApp.Route.Route -> Nextjs.Page.Page
routeToPage route = NextjsApp.Route.extractFromPagesRec route pagesRec

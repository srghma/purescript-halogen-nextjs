module NextjsApp.PageImplementations.Index (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import NextjsApp.Link as NextjsApp.Link
import NextjsApp.Route
import Data.Variant

allRoutes :: Array (Variant WebRoutesWithParamRow)
allRoutes =
  [ route__Examples__Ace
  , route__Examples__Basic
  , route__Examples__Components
  , route__Examples__ComponentsInputs
  , route__Examples__ComponentsMultitype
  , route__Examples__EffectsAffAjax
  , route__Examples__EffectsEffectRandom
  , route__Examples__HigherOrderComponents
  , route__Examples__Interpret
  , route__Examples__KeyboardInput
  , route__Examples__Lifecycle
  , route__Examples__DeeplyNested
  , route__Examples__TextNodes
  , route__Examples__Lazy
  , route__Index
  , route__Login
  , route__Register
  , route__Secret
  , route__VerifyUserEmailWeb "dummy_token"
  ]

type Query
  = Const Void

type Input
  = Unit

type Message
  = Void

type State
  = Unit

data Action
  = Void

type ChildSlots
  = ( mylink :: Slot NextjsApp.Link.Query NextjsApp.Link.Message (Variant WebRoutesWithParamRow)
    )

component :: H.Component Query Input Message AppM
component =
  H.mkComponent
    { initialState: const unit
    , render: const render
    , eval: H.mkEval $ H.defaultEval
    }

render :: HH.ComponentHTML Action ChildSlots AppM
render =
  HH.div_
    [ HH.text "test"
    , HH.ul_
        $ allRoutes
        <#> \route ->
            HH.li_
              $ [ HH.slot
                    (SProxy :: SProxy "mylink")
                    route
                    NextjsApp.Link.component
                    { route, text: show route }
                    absurd
                ]
    ]

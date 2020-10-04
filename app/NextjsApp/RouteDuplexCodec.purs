module NextjsApp.RouteDuplexCodec where

routeCodec :: Routing.Duplex.RouteDuplex' Routes
routeCodec = Routing.Duplex.root $ Routing.Duplex.sum
  { "Index":    Routing.Duplex.noArgs
  , "Login":    "login" / Routing.Duplex.noArgs
  , "Signup":   "signup" / Routing.Duplex.noArgs
  , "Secret":   "secret" / Routing.Duplex.noArgs
  , "RoutesExamples": "routesexamples" / routesexamplesCodec
  }
  where
    routesexamplesCodec :: Routing.Duplex.RouteDuplex' RoutesExamples
    routesexamplesCodec = Routing.Duplex.sum
      { "RoutesExamples__Ace":                   "ace" / Routing.Duplex.noArgs
      , "RoutesExamples__Basic":                 "basic" / Routing.Duplex.noArgs
      , "RoutesExamples__Components":            "components" / Routing.Duplex.noArgs
      , "RoutesExamples__ComponentsInputs":      "components-inputs" / Routing.Duplex.noArgs
      , "RoutesExamples__ComponentsMultitype":   "components-multitype" / Routing.Duplex.noArgs
      , "RoutesExamples__EffectsAffAjax":        "effects-aff-ajax" / Routing.Duplex.noArgs
      , "RoutesExamples__EffectsEffectRandom":   "effects-effect-random" / Routing.Duplex.noArgs
      , "RoutesExamples__HigherOrderComponents": "higher-order-components" / Routing.Duplex.noArgs
      , "RoutesExamples__Interpret":             "interpret" / Routing.Duplex.noArgs
      , "RoutesExamples__KeyboardInput":         "keyboard-input" / Routing.Duplex.noArgs
      , "RoutesExamples__Lifecycle":             "lifecycle" / Routing.Duplex.noArgs
      , "RoutesExamples__DeeplyNested":          "deeply-nested" / Routing.Duplex.noArgs
      , "RoutesExamples__DynamicInput":          "dynamic-input" / Routing.Duplex.noArgs
      , "RoutesExamples__TextNodes":             "text-nodes" / Routing.Duplex.noArgs
      , "RoutesExamples__Lazy":                  "lazy" / Routing.Duplex.noArgs
      }


module Lib.Pages.Index.Default (component) where

import Protolude (SProxy(..), absurd, const, show, unit, ($), (<#>))

import Halogen as H
import Halogen.HTML as HH
import Lib.Link as Lib.Link
import Nextjs.Route (Route(..))
import Nextjs.AppM (AppM)

allRoutes :: Array Route
allRoutes =
  [ Ace
  , Basic
  , Components
  , ComponentsInputs
  , ComponentsMultitype
  , EffectsAffAjax
  , EffectsEffectRandom
  , HigherOrderComponents
  , Interpret
  , KeyboardInput
  , Lifecycle
  , DynamicInput
  , DeeplyNested
  , TextNodes
  , Lazy
  ]

component :: forall q i o . H.Component q i o AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: forall t1 t15 t18 t26 t4.
  MonadEffect t18 => Navigate t18 => MonadAsk
                                       { clientPagesManifest :: { "Ace" :: { css :: Array String
                                                                           , js :: Array String
                                                                           }
                                                                , "Basic" :: { css :: Array String
                                                                             , js :: Array String
                                                                             }
                                                                , "Components" :: { css :: Array String
                                                                                  , js :: Array String
                                                                                  }
                                                                , "ComponentsInputs" :: { css :: Array String
                                                                                        , js :: Array String
                                                                                        }
                                                                , "ComponentsMultitype" :: { css :: Array String
                                                                                           , js :: Array String
                                                                                           }
                                                                , "DeeplyNested" :: { css :: Array String
                                                                                    , js :: Array String
                                                                                    }
                                                                , "DynamicInput" :: { css :: Array String
                                                                                    , js :: Array String
                                                                                    }
                                                                , "EffectsAffAjax" :: { css :: Array String
                                                                                      , js :: Array String
                                                                                      }
                                                                , "EffectsEffectRandom" :: { css :: Array String
                                                                                           , js :: Array String
                                                                                           }
                                                                , "HigherOrderComponents" :: { css :: Array String
                                                                                             , js :: Array String
                                                                                             }
                                                                , "Index" :: { css :: Array String
                                                                             , js :: Array String
                                                                             }
                                                                , "Interpret" :: { css :: Array String
                                                                                 , js :: Array String
                                                                                 }
                                                                , "KeyboardInput" :: { css :: Array String
                                                                                     , js :: Array String
                                                                                     }
                                                                , "Lazy" :: { css :: Array String
                                                                            , js :: Array String
                                                                            }
                                                                , "Lifecycle" :: { css :: Array String
                                                                                 , js :: Array String
                                                                                 }
                                                                , "TextNodes" :: { css :: Array String
                                                                                 , js :: Array String
                                                                                 }
                                                                }
                                       , document :: HTMLDocument
                                       , head :: HTMLHeadElement
                                       , intersectionObserver :: IntersectionObserver
                                       , intersectionObserverEvent :: Event (Array IntersectionObserverEntry)
                                       | t26
                                       }
                                       t18
                                      => t1
                                         -> HTML
                                              (ComponentSlot
                                                 ( mylink :: Slot (Const Void) Void Route
                                                 | t15
                                                 )
                                                 t18
                                                 t4
                                              )
                                              t4
render state =
  HH.ul_ $
    allRoutes <#> (\route ->
      HH.li_ $
        let route' = show route
        in
          [ HH.slot (SProxy :: SProxy
 "mylink") route Lib.Link.component { route, text: route' } absurd
          ]
      )

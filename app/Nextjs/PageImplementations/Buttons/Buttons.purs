module Nextjs.PageImplementations.Buttons.Buttons (component) where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import RMWC.Blocks.Button as RMWC.Blocks.Button
import RMWC.Blocks.CircularProgress as RMWC.Blocks.CircularProgress

type State = Unit

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: forall m. State -> H.ComponentHTML Void () m
render state = HH.div_
  [ HH.text "Button"
  , RMWC.Blocks.Button.textButton "Button"
  , RMWC.Blocks.Button.textButtonWithIcon { leftIcon: Just "favorite", text: "Icon", rightIcon: Nothing }
  , RMWC.Blocks.Button.textButtonWithIcon { leftIcon: Nothing, text: "Trailing", rightIcon: Just "keyboard_arrow_right" }
  , RMWC.Blocks.Button.textButtonWithCustomIcon
    { leftIcon: Just
      (RMWC.Blocks.CircularProgress.circularProgressIndeterminate
        { progress: Nothing
        , size: RMWC.Blocks.CircularProgress.Xsmall
        }
      )
    , text: "Trailing"
    , rightIcon: Nothing
    }
  ]

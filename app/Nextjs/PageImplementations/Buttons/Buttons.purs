module Nextjs.PageImplementations.Buttons.Buttons (component) where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import RMWC.Blocks.Button as RMWC.Blocks.Button
import RMWC.Blocks.CircularProgress as RMWC.Blocks.CircularProgress
import RMWC.Blocks.LinearProgress as RMWC.Blocks.LinearProgress
import RMWC.Blocks.Avatars as RMWC.Blocks.Avatars
import RMWC.Blocks.Badges as RMWC.Blocks.Badges
import Data.Percent as Percent
import Protolude.Url as Url

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
  , RMWC.Blocks.Button.button $ RMWC.Blocks.Button.defaultOptions { label = "Button" }
  , RMWC.Blocks.Button.button $ RMWC.Blocks.Button.defaultOptions { leftIcon = RMWC.Blocks.Button.Icon_Text "favorite", label = "Icon" }
  , RMWC.Blocks.Button.button $ RMWC.Blocks.Button.defaultOptions { label = "Trailing", rightIcon = RMWC.Blocks.Button.Icon_Text "keyboard_arrow_right" }
  , RMWC.Blocks.Button.button $ RMWC.Blocks.Button.defaultOptions
    { leftIcon = RMWC.Blocks.Button.Icon_Custom (RMWC.Blocks.CircularProgress.circularProgressIndeterminate RMWC.Blocks.CircularProgress.Xsmall)
    , label = "Trailing"
    }
  , RMWC.Blocks.CircularProgress.circularProgressDeterminate { size: RMWC.Blocks.CircularProgress.Xsmall, progress: Percent.unsafePercent 0.5 }
  , RMWC.Blocks.LinearProgress.linearProgress { progress: Percent.unsafePercent 0.6, buffer: Percent.unsafePercent 0.8 }
  , RMWC.Blocks.LinearProgress.linearProgressIndeterminate
  , RMWC.Blocks.Avatars.avatarImage { size: RMWC.Blocks.Avatars.Medium, url: Url.unsafeUrl "https://rmwc.io/images/avatars/blackwidow.png", name: "Natalia Alianovna Romanova", square: false, contain: false }
  , RMWC.Blocks.Avatars.avatarInitials { size: RMWC.Blocks.Avatars.Medium, name: "Natalia Alianovna Romanova", square: false, contain: false }
  , RMWC.Blocks.Badges.inlineNoContent
  , RMWC.Blocks.Badges.inlineWithContent [HH.text "22+"]
  ]

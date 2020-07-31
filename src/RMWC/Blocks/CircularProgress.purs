module RMWC.Blocks.CircularProgress where

import Protolude

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Material.Classes.Button
import MaterialIconsFont.Classes
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA

size_xsmall = 18
size_small =  20
size_medium = 24
size_large =  36
size_xlarge = 48

type CircularProgress =
  { min      :: Maybe Integer
  , max      :: Maybe Integer
  , progress :: Maybe Integer
  , size     :: Integer
  }

buttonRipple :: forall i w. HH.HTML w i
buttonRipple = HH.div [ HP.class_ mdc_button__ripple ] []

buttonLabel :: forall i w. Array (HH.HTML w i) -> HH.HTML w i
buttonLabel = HH.span [ HP.class_ mdc_button__label ]

iIcon = HH.i
  [ HP.classes [ material_icons, mdc_button__icon ]
  , Halogen.HTML.Properties.ARIA.hidden "true"
  ]

textButton
  :: ∀ w i
   . String
  -> HH.HTML w i
textButton text =
  HH.button
    [ HP.class_ mdc_button ]
    [ buttonRipple
    , buttonLabel [ HH.text text ]
    ]

textButtonWithIcon
  :: ∀ w i
  . { leftIcon :: Maybe String, rightIcon :: Maybe String, text :: String }
  -> HH.HTML w i
textButtonWithIcon =
  let
    maybeIcon = maybe [] (\icon -> [ iIcon [ HH.text icon ] ])
   in \{ leftIcon, rightIcon, text } ->
    HH.button [ HP.class_ mdc_button ] $ [ buttonRipple ] <> maybeIcon leftIcon <> [ buttonLabel [ HH.text text ] ] <> maybeIcon rightIcon

module RMWC.Blocks.CircularProgress where

import Protolude (Maybe, maybe, ($), (<>))

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Material.Classes.Button (mdc_button, mdc_button__icon, mdc_button__label, mdc_button__ripple)
import MaterialIconsFont.Classes (material_icons)
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA

size_xsmall :: Int
size_xsmall = 18
size_small :: Int
size_small =  20
size_medium :: Int
size_medium = 24
size_large :: Int
size_large =  36
size_xlarge :: Int
size_xlarge = 48

type CircularProgress =
  { min      :: Maybe Int
  , max      :: Maybe Int
  , progress :: Maybe Int
  , size     :: Int
  }

buttonRipple :: forall i w. HH.HTML w i
buttonRipple = HH.div [ HP.class_ mdc_button__ripple ] []

buttonLabel :: forall i w. Array (HH.HTML w i) -> HH.HTML w i
buttonLabel = HH.span [ HP.class_ mdc_button__label ]

iIcon :: forall t6 t7. Array (HTML t7 t6) -> HTML t7 t6
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

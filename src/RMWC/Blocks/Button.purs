module RMWC.Blocks.Button where

import Protolude (Maybe, maybe, ($), (<>))

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Material.Classes.Button (mdc_button, mdc_button__icon, mdc_button__label, mdc_button__ripple)
import RMWC.Classes.Icon
import MaterialIconsFont.Classes (material_icons)
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA

buttonRipple :: forall i w. HH.HTML w i
buttonRipple = HH.div [ HP.class_ mdc_button__ripple ] []

buttonLabel :: forall i w. Array (HH.HTML w i) -> HH.HTML w i
buttonLabel = HH.span [ HP.class_ mdc_button__label ]

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
    iIcon =
      HH.i
      [ HP.classes [ rmwc_icon, material_icons, mdc_button__icon ]
      , Halogen.HTML.Properties.ARIA.hidden "true"
      ]

    maybeIcon = maybe [] (\icon -> [ iIcon [ HH.text icon ] ])
   in \{ leftIcon, rightIcon, text } ->
    HH.button [ HP.class_ mdc_button ] $ [ buttonRipple ] <> maybeIcon leftIcon <> [ buttonLabel [ HH.text text ] ] <> maybeIcon rightIcon

textButtonWithCustomIcon
  :: ∀ w i
  . { leftIcon :: Maybe (HH.HTML w i), rightIcon :: Maybe (HH.HTML w i), text :: String }
  -> HH.HTML w i
textButtonWithCustomIcon =
  let
    iIcon =
      HH.i
      [ HP.classes [ rmwc_icon, rmwc_icon____component, material_icons, mdc_button__icon ]
      , Halogen.HTML.Properties.ARIA.hidden "true"
      ]

    maybeIcon = maybe [] (\icon -> [ iIcon [ icon ] ])
   in \{ leftIcon, rightIcon, text } ->
    HH.button [ HP.class_ mdc_button ] $ [ buttonRipple ] <> maybeIcon leftIcon <> [ buttonLabel [ HH.text text ] ] <> maybeIcon rightIcon

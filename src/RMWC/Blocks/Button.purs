module RMWC.Blocks.Button where

import Protolude (Maybe, maybe, ($), (<>))

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Material.Classes.Button (mdc_button, mdc_button__icon, mdc_button__label, mdc_button__ripple)
import MaterialIconsFont.Classes (material_icons)
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA

buttonRipple :: forall i w. HH.HTML w i
buttonRipple = HH.div [ HP.class_ mdc_button__ripple ] []

buttonLabel :: forall i w. Array (HH.HTML w i) -> HH.HTML w i
buttonLabel = HH.span [ HP.class_ mdc_button__label ]

iIcon :: forall t1 t2. Array (HTML t2 t1) -> HTML t2 t1
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

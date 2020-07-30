module RMWC.Blocks.Button where

import Protolude

import DOM.HTML.Indexed (HTMLbutton, HTMLdiv)
import Halogen.HTML (ClassName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

mdc_button :: ClassName
mdc_button = ClassName "mdc-button"

textButton
  :: ∀ p i
   . String
  -> HH.HTML p i
textButton text =
  HH.button
    [ HP.class_ (HH.ClassName "mdc-button") ]
    [ HH.div [ HP.class_ (HH.ClassName "mdc-button__ripple") ] []
    , HH.span [ HP.class_ (HH.ClassName "mdc-button__label")] [ HH.text text ]
    ]

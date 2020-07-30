module RMWC.Blocks.Button where

import Protolude

import DOM.HTML.Indexed (HTMLbutton, HTMLdiv)
import Halogen.HTML (ClassName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Classes.Material.Button

textButton
  :: ∀ p i
   . String
  -> HH.HTML p i
textButton text =
  HH.button
    [ HP.class_ mdc_button ]
    [ HH.div [ HP.class_ mdc_button__ripple ] []
    , HH.span [ HP.class_ mdc_button__label] [ HH.text text ]
    ]

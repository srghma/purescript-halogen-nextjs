module RMWC.Blocks.Avatars where

import Protolude

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import Halogen.HTML.Core (AttrName(..))
import Halogen.SVG.Attributes as SVG.Attributes
import Halogen.SVG.Elements as SVG
import Math as Math
import Unsafe.Coerce (unsafeCoerce)
import Halogen.HTML (ClassName(..))
import Material.Classes.LinearProgress
import Data.Percent (Percent)

linearProgress :: ∀ w i . { progress :: Percent, buffer :: Percent } -> HH.HTML w i
linearProgress { buffer, progress } =
  HH.div
    [ HP.attr (AttrName "role") "progressbar"
    , Halogen.HTML.Properties.ARIA.valueMin "0"
    , Halogen.HTML.Properties.ARIA.valueMax "1"
    , Halogen.HTML.Properties.ARIA.valueNow (show progress)
    , HP.class_ mdc_linear_progress
    ]
    [ HH.div [ HP.class_ mdc_linear_progress__buffering_dots ] []
    , HH.div
      [ HP.class_ mdc_linear_progress__buffer
      , HP.attr (AttrName "style") $ "transform: scaleX(" <> show buffer <>  ");"
      ]
      []
    , HH.div
      [ HP.classes [ mdc_linear_progress__bar, mdc_linear_progress__primary_bar ]
      , HP.attr (AttrName "style") $ "transform: scaleX(" <> show progress <>  ");"
      ]
      [ HH.span [ HP.class_ mdc_linear_progress__bar_inner ] []
      ]
    , HH.div
      [ HP.classes [ mdc_linear_progress__bar, mdc_linear_progress__secondary_bar ]
      ]
      [ HH.span [ HP.class_ mdc_linear_progress__bar_inner ] []
      ]
    ]

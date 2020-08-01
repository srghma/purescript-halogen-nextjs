module RMWC.Blocks.CircularProgress where

import Protolude
import RMWC.Classes.CircularProgress

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import Halogen.HTML.Core (AttrName(..))
import Halogen.SVG.Attributes as SVG.Attributes
import Halogen.SVG.Elements as SVG
import Halogen.XLINK.Attributes as XLINK
import Halogen.XLINK.Core as SVXLINK
import Math as Math
import Unsafe.Coerce (unsafeCoerce)
import Halogen.HTML (ClassName(..))

data Size
  = Xsmall
  | Small
  | Medium
  | Large
  | Xlarge
  | Custom Number

sizeToNumber :: Size -> Number
sizeToNumber Xsmall          = 18.0
sizeToNumber Small           = 20.0
sizeToNumber Medium          = 24.0
sizeToNumber Large           = 36.0
sizeToNumber Xlarge          = 48.0
sizeToNumber (Custom number) = number

sizeToClassName :: Size -> Array ClassName
sizeToClassName Xsmall     = [ rmwc_circular_progress____size_xsmall ]
sizeToClassName Small      = [ rmwc_circular_progress____size_small ]
sizeToClassName Medium     = [ rmwc_circular_progress____size_medium ]
sizeToClassName Large      = [ rmwc_circular_progress____size_large ]
sizeToClassName Xlarge     = [ rmwc_circular_progress____size_xlarge ]
sizeToClassName (Custom _) = []

newtype Percent = Percent Number

calcPercent :: Number -> Number -> Number -> Percent
calcPercent min max value =
  if value < min then Percent 0.0
  else if value > max then Percent 1.0
  else Percent $ (value - min) / (max - min)

unsafePercent :: Number -> Percent
unsafePercent = unsafeCoerce

type CircularProgressProps =
  { progress :: Maybe Percent
  , size     :: Size
  }

circularProgressIndeterminate
  :: ∀ w i
   . CircularProgressProps
  -> HH.HTML w i
circularProgressIndeterminate circularProgressProps =
  let
    size' = sizeToNumber circularProgressProps.size

    circleProps =
      [ SVG.Attributes.class_ rmwc_circular_progress__path
      , SVG.Attributes.cx (size' / 2.0)
      , SVG.Attributes.cy (size' / 2.0)
      , SVG.Attributes.r (size' / 2.4)
      ]

    styleAttribute =
      case circularProgressProps.progress of
           Nothing -> []
           Just (Percent progress) ->
             let
                n = 2.0 * Math.pi * (size' / 2.4) * progress
              in [ HP.attr (AttrName "style") ("stroke-dasharray: " <> show n <> "666.66%;") ]
  in
    HH.div
      [ Halogen.HTML.Properties.ARIA.valueMin "0"
      , Halogen.HTML.Properties.ARIA.valueMax "1"
      , HP.classes $
          [ rmwc_circular_progress ]
          <> sizeToClassName circularProgressProps.size
          <> (maybe [rmwc_circular_progress____indeterminate] (const []) circularProgressProps.progress)
      ]
      [ SVG.svg
          [ SVG.Attributes.class_ rmwc_circular_progress__circle
          , SVG.Attributes.viewBox 0.0 0.0 size' size'
          ]
          [ SVG.circle
            (circleProps <> styleAttribute)
            []
          ]
      ]

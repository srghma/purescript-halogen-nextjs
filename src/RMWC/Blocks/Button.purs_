module RMWC.Blocks.Button where

import Material.Classes.Button
import RMWC.Classes.Icon

import Halogen (AttrName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import MaterialIconsFont.Classes (material_icons)
import Protolude (Maybe, maybe, ($), (<>))

buttonRipple :: forall i w. HH.HTML w i
buttonRipple = HH.div [ HP.class_ mdc_button__ripple ] []

buttonLabel :: forall i w. Array (HH.HTML w i) -> HH.HTML w i
buttonLabel = HH.span [ HP.class_ mdc_button__label ]

dangerStyle :: String
dangerStyle = "--mdc-theme-primary: var(--mdc-theme-error); mdc-theme-on-primary: var(--mdc-theme-on-error);"

--------------------

data Icon w i
  = Icon_None
  | Icon_Text String
  | Icon_Custom (HH.HTML w i)

type Options w i =
  { leftIcon :: Icon w i
  , rightIcon :: Icon w i
  , label :: String
  -- | , dense :: Boolean -- no such class in @material
  , raised :: Boolean
  , unelevated :: Boolean
  , outlined :: Boolean
  , danger :: Boolean
  }

defaultOptions :: forall w i . Options w i
defaultOptions =
  { leftIcon: Icon_None
  , rightIcon: Icon_None
  , label: ""
  , raised: false
  , unelevated: false
  , outlined: false
  , danger: false
  }

button
  :: ∀ w i
  . Options w i
  -> HH.HTML w i
button =
  let
    renderIcon' extraClasses =
      HH.i
      [ HP.classes
        ( [ rmwc_icon
          , material_icons
          , mdc_button__icon
          ] <> extraClasses
        )
      , Halogen.HTML.Properties.ARIA.hidden "true"
      ]

    renderIcon Icon_None          = []
    renderIcon (Icon_Text text)   = [ renderIcon' [] [ HH.text text ] ]
    renderIcon (Icon_Custom html) = [ renderIcon' [ rmwc_icon____component ] [ html ] ]
   in \options ->
     HH.button
     ( [ HP.classes $
         [ mdc_button ]
         <> (if options.raised then [mdc_button____raised] else [])
         <> (if options.unelevated then [mdc_button____unelevated] else [])
         <> (if options.outlined then [mdc_button____outlined] else [])
       ]
       <> (if options.danger then [ HP.attr (AttrName "style") dangerStyle ] else [])
     )
     (  [ buttonRipple ]
     <> renderIcon options.leftIcon
     <> [ buttonLabel [ HH.text options.label ] ]
     <> renderIcon options.rightIcon
     )

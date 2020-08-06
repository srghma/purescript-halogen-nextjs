module RMWC.Blocks.Fab where

import Material.Classes.Fab
import RMWC.Classes.Icon

import Halogen (AttrName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import MaterialIconsFont.Classes
import Protolude

fabRipple :: forall i w. HH.HTML w i
fabRipple = HH.div [ HP.class_ mdc_fab__ripple ] []

--------------------

data Icon
  = Icon_None
  | Icon_Text String

data Extended
  = Extended_No
  | Extended_Yes String

type Options =
  { icon :: Icon
  , trailingIcon :: Icon
  , mini :: Boolean
  , extended :: Extended
  -- | , exited :: Boolean
  }

defaultOptions :: Options
defaultOptions =
  { icon: Icon_None
  , trailingIcon: Icon_None
  , mini: false
  , extended: Extended_No
  }

fab
  :: ∀ w i
  . Options
  -> HH.HTML w i
fab =
  let
    renderIcon' extraClasses =
      HH.i
      [ HP.classes
        ( [ rmwc_icon
          , material_icons
          , mdc_fab__icon
          ] <> extraClasses
        )
      , Halogen.HTML.Properties.ARIA.hidden "true"
      ]

    renderIcon Icon_None          = []
    renderIcon (Icon_Text text)   = [ renderIcon' [] [ HH.text text ] ]
   in \options ->
     HH.button
     ( [ HP.classes $
         [ mdc_fab ]
         <> (if options.mini then [mdc_fab____mini] else [])
         <> (case options.extended of
                  Extended_No -> []
                  Extended_Yes _ -> [mdc_fab____extended]
            )
       ]
     )
     (  [ fabRipple ]
     <> renderIcon options.icon
     <> (case options.extended of
              Extended_No -> []
              Extended_Yes label -> [HH.div [HP.class_ mdc_fab__label] [ HH.text label ]]
        )
     <> renderIcon options.trailingIcon
     )

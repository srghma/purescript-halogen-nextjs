module RMWC.Blocks.IconButton where

import Material.Classes.IconButton
import RMWC.Classes.Icon

import Halogen (AttrName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import MaterialIconsFont.Classes
import Protolude

iconButtonRipple :: forall i w. HH.HTML w i
iconButtonRipple = HH.div [ HP.class_ mdc_icon_button__ripple ] []

--------------------

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

iconButton
  :: ∀ w i
  . Options
  -> HH.HTML w i
iconButton options =
  HH.button
    [ HP.role "button"
    , HP.tabindex "0"
    , HP.aria-label options.label
    , HP.classes
      [ rmwc_icon
      , rmwc_icon____ligature
      , material_icons
      , mdc_ripple_upgraded____unbounded
      , mdc_ripple_upgraded
      , mdc_icon_button
      ]
    ]
    [ HH.text options.icon
    ]

iconButton
  :: ∀ w i
  . Options
  -> HH.HTML w i
iconButton =
  let
    renderIcon' extraClasses =
      HH.i
      [ HP.classes
        ( [ rmwc_icon
          , material_icons
          , mdc_icon_button__icon
          ] <> extraClasses
        )
      , Halogen.HTML.Properties.ARIA.hidden "true"
      ]

    renderIcon Icon_None          = []
    renderIcon (Icon_Text text)   = [ renderIcon' [] [ HH.text text ] ]
   in \options ->
     HH.button
     ( [ HP.classes $
         [ mdc_icon_button ]
         <> (if options.mini then [mdc_icon_button____mini] else [])
         <> (case options.extended of
                  Extended_No -> []
                  Extended_Yes _ -> [mdc_icon_button____extended]
            )
       ]
     )
     (  [ iconButtonRipple ]
     <> renderIcon options.icon
     <> (case options.extended of
              Extended_No -> []
              Extended_Yes label -> [HH.div [HP.class_ mdc_icon_button__label] [ HH.text label ]]
        )
     <> renderIcon options.trailingIcon
     )

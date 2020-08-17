module MWCComponents.Blocks.Button where

import Material.Classes.Button
import Protolude
import RMWC.Classes.Icon

import Halogen (AttrName(..))
import Halogen.HTML (IProp)
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import MaterialIconsFont.Classes (material_icons)

-- from https://github.com/material-components/material-components-web-components/blob/18d6b808bf3827a0f1a6bc1bf41283eb2464fb25/packages/button/src/mwc-button-base.ts#L26
type Config r i =
  { raised       :: Boolean
  , unelevated   :: Boolean
  , outlined     :: Boolean
  , dense        :: Boolean
  , disabled     :: Boolean
  , trailingIcon :: Boolean
  , fullwidth    :: Boolean
  , icon         :: String
  , label        :: String
  , props        :: Array (IProp r i)
  }

defaultConfig :: forall r i . Config r i
defaultConfig =
  { raised: false
  , unelevated: false
  , outlined: false
  , dense: false
  , disabled: false
  , trailingIcon: false
  , fullwidth: false
  , icon: ""
  , label: ""
  , props: []
  }

button
  :: ∀ r w i
   . Config r i
  -> Array (HH.HTML w i)
  -> HH.HTML w i
button config =
  HH.element
  (HH.ElemName "mwc-button")
  ( [ HP.prop (HH.PropName "raised") config.raised
    , HP.prop (HH.PropName "unelevated") config.unelevated
    , HP.prop (HH.PropName "outlined") config.outlined
    , HP.prop (HH.PropName "dense") config.dense
    , HP.prop (HH.PropName "disabled") config.disabled
    , HP.prop (HH.PropName "trailingIcon") config.trailingIcon
    , HP.prop (HH.PropName "fullwidth") config.fullwidth
    , HP.prop (HH.PropName "icon") config.icon
    , HP.prop (HH.PropName "label") config.label
    ]
  <> config.props
  )

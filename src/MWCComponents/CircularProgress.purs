module MWCComponents.Blocks.CircularProgress where

import Material.Classes.Button
import Protolude
import RMWC.Classes.Icon
import Data.Percent (Percent)
import Data.Percent as Percent

import Halogen (AttrName(..))
import Halogen.HTML (IProp)
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import MaterialIconsFont.Classes (material_icons)

type Config r i =
  { state   :: State
  , density :: Int
  , props   :: Array (IProp r i)
  }

data State
  = Indeterminate
  | Determinate Percent
  | Finished

defaultConfig :: forall r i . Config r i
defaultConfig =
  { state: Indeterminate
  , density: 0
  , props: []
  }

circularProgress
  :: ∀ r w i
   . Config r i
  -> Array (HH.HTML w i)
  -> HH.HTML w i
circularProgress config =
  HH.element
  (HH.ElemName "mwc-circular-progress")
  ( [ case config.state of
           Indeterminate       -> HP.prop (HH.PropName "indeterminate") true
           Determinate percent -> HP.prop (HH.PropName "progress") (Percent.toNumber percent)
           Finished            -> HP.prop (HH.PropName "closed") true
    , HP.prop (HH.PropName "density") config.density
    ]
  <> config.props
  )

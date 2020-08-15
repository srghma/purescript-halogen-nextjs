module RMWC.Blocks.Button where

import Material.Classes.Button
import RMWC.Classes.Icon

import Halogen (AttrName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import MaterialIconsFont.Classes (material_icons)
import Protolude (Maybe, maybe, ($), (<>))

type Config =
  { icon :: Maybe String
  , trailingIcon :: Boolean
  , disabled :: Boolean
  , dense :: Boolean
  , href :: Maybe String
  , target :: Maybe String
  -- | , additionalAttributes :: Array (Html.Attribute msg)
  -- | , onClick :: Maybe msg
  , touch :: Boolean
  }

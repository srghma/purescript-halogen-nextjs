module RMWC.Blocks.Icon where

import MaterialIconsFont.Classes
import Protolude
import RMWC.Classes.Icon

import Halogen (AttrName(..), ClassName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import Protolude.Url (Url)
import Protolude.Url as Url

data Size
  = Xsmall
  | Small
  | Medium
  | Large
  | Xlarge

sizeToClassName :: Size -> ClassName
sizeToClassName Xsmall = rmwc_icon____size_xsmall
sizeToClassName Small  = rmwc_icon____size_small
sizeToClassName Medium = rmwc_icon____size_medium
sizeToClassName Large  = rmwc_icon____size_large
sizeToClassName Xlarge = rmwc_icon____size_xlarge

maybeSizeToClassName :: Maybe Size -> Array ClassName
maybeSizeToClassName = maybe [] (\x -> [sizeToClassName x])

iconLigature :: { name :: String, size :: Maybe Size } -> forall w i . HH.HTML w i
iconLigature options =
  HH.i
  [ HP.classes $ [ rmwc_icon, material_icons ] <> maybeSizeToClassName options.size
  ]
  [ HH.text options.name
  ]

iconComponent :: forall w i . Maybe Size -> Array (HH.HTML w i) -> HH.HTML w i
iconComponent size =
  HH.i
  [ HP.classes $ [rmwc_icon, rmwc_icon____component, material_icons] <> maybeSizeToClassName size
  ]

iconUrl :: forall w i . { url :: Url, size :: Maybe Size } -> HH.HTML w i
iconUrl options =
  HH.i
  [ HP.classes $ [rmwc_icon, rmwc_icon____url, material_icons] <> maybeSizeToClassName options.size
  , HP.attr (AttrName "style") $ "background-image: url(" <> Url.unUrl options.url <> ");"
  ]
  []

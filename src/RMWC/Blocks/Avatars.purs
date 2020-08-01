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
import RMWC.Classes.Icon
import RMWC.Classes.Avatar
import MaterialIconsFont.Classes

avatarImage
  :: forall w i
   . { size :: Size
     , src :: Url
     , name :: String
     , square :: Boolean
     , contain :: Boolean
     }
  -> HH.HTML w i
avatarImage _ =
  HH.span
    [ HP.title "Natalia Alianovna Romanova"
    , HP.classes
        [ rmwc_icon
        , rmwc_icon____component
        , material_icons
        , rmwc_avatar
        , rmwc_avatar____xsmall
        , rmwc_avatar____has_image
        ]
    ]
    [ HH.div
        [ HP.class_ rmwc_avatar__icon
        , HP.attr (AttrName "style") "background_image: url(images/avatars/blackwidow.png); background_size: cover;"
        ]
        []
    , HH.div
        [ HP.class_ rmwc_avatar__text ]
        [ HH.div
            [ HP.class_ rmwc_avatar__text_inner ]
            [ HH.text "NR" ]
        ]
    ]

avatarInitials
  :: forall w i
   . { size :: Size
     , name :: String
     , square :: Boolean
     , contain :: Boolean
     }
  -> HH.HTML w i
avatarInitials _ =
  HH.span
    [ HP.title "Natalia Alianovna Romanova"
    , HP.classes
        [ rmwc_icon
        , rmwc_icon____component
        , material_icons
        , rmwc_avatar
        , rmwc_avatar____xsmall
        , rmwc_avatar____has_image
        ]
    ]
    [ HH.div
        [ HP.class_ rmwc_avatar__icon
        , HP.attr (AttrName "style") "background_image: url(images/avatars/blackwidow.png); background_size: cover;"
        ]
        []
    , HH.div
        [ HP.class_ rmwc_avatar__text ]
        [ HH.div
            [ HP.class_ rmwc_avatar__text_inner ]
            [ HH.text "NR" ]
        ]
    ]

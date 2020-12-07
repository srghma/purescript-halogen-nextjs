module Worker.EmailUI where

import Protolude
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

link_to_styled text url =
  HH.a
  [ HP.style "color: #f57a12; text-decoration: none; font-style: oblique; font-weight: bold;"
  , HP.href url
  ]
  [ HH.text text
  ]

break =
  HH.div
  [ HP.style "display: none;"
  ]
  [ HH.br_
  , HH.br_
  ]


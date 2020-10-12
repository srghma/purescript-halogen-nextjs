module NextjsApp.PageImplementations.Login.Render where

import Protolude

import Data.Array as Array
import Data.Either (Either(..))
import Data.Email (Email)
import Data.Email as Email
import Data.Int as Int
import Data.Lens.Record as Lens
import Data.Maybe (Maybe(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Variant (Variant, inj)
import Formless as F
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import Material.Classes.LayoutGrid
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import Halogen.Component as Halogen.Component
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.Data.Password
import NextjsApp.PageImplementations.Login.Types

render =
  \state ->
    HH.div
      [ HP.class_ mdc_layout_grid ]
      [ HH.div
          [ HP.class_ mdc_layout_grid__inner ]
          [ HH.img [ HP.classes [ mdc_layout_grid__cell, mdc_layout_grid__cell____align_middle, mdc_layout_grid__cell____span_3 ], HP.alt "logo", HP.src purescriptLogoSrc ]
          , HH.slot F._formless unit formComponent unit Action__HandleLoginForm
          ]
      ]

module NextjsApp.PageImplementations.Login.Render where

import Material.Classes.LayoutGrid
import NextjsApp.Data.Password
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.PageImplementations.Login.Types
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
import Halogen.Component as Halogen.Component
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Query.ChildQuery (ChildQueryBox)
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Login.Types

renderError :: Maybe LoginError -> String
renderError = maybe ""
  case _ of
       LoginError__NotConfirmed       -> "Email not confirmed"
       LoginError__EmailNotRegistered -> "Email not registered"
       LoginError__WrongPassword      -> "Wrong password"
       LoginError__UnknownError error -> "Unknown error: " <> error

render ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  State -> HH.ComponentHTML Action ChildSlots m
render =
  \state ->
    HH.div
      [ HP.class_ mdc_layout_grid ]
      [ HH.div
          [ HP.class_ mdc_layout_grid__inner ]
          [ HH.text $ renderError state.loginError
          , HH.img [ HP.classes [ mdc_layout_grid__cell, mdc_layout_grid__cell____align_middle, mdc_layout_grid__cell____span_3 ], HP.alt "logo", HP.src purescriptLogoSrc ]
          , HH.slot F._formless unit formComponent unit Action__HandleLoginForm
          ]
      ]

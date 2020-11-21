module NextjsApp.PageImplementations.Login.Render where

import Material.Classes.LayoutGrid
import NextjsApp.Data.Password
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.PageImplementations.Login.Types
import Protolude
import NextjsApp.PageImplementations.Login.Css as NextjsApp.PageImplementations.Login.Css

import Data.Array as Array
import Data.Either (Either(..))
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
       LoginError__UsernameOrEmailNotRegistered -> "Username or email not registered or not confirmed"
       LoginError__WrongPassword      -> "Wrong password"
       LoginError__UnknownError error -> "Unknown error: " <> error

render ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  State ->
  HH.ComponentHTML Action ChildSlots m
render = \state ->
  HH.div
    [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.root ]
    [ HH.text (renderError state.loginError)
    , HH.img
      [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.logo
      , HP.alt "logo"
      , HP.src purescriptLogoSrc
      ]
    , HH.slot F._formless unit formComponent unit Action__HandleLoginForm
    ]

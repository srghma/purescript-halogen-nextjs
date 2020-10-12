module NextjsApp.PageImplementations.Login.Form.Types where

import Material.Classes.LayoutGrid
import NextjsApp.Data.Password
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Data.EmailFromString
import NextjsApp.Data.EmailFromString as NextjsApp.Data.EmailFromString
import Protolude

import Api.Object.User as Api.Object.User
import Api.Query as Api.Query
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
import GraphQLClient as GraphQLClient
import Halogen as H
import Halogen.Component as Halogen.Component
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.ApiUrl

data UserAction
  = UserAction__RegisterButtonClick Button.Message

type LoginFormRow f =
  ( email    :: f EmailError    String Email
  , password :: f PasswordError String Password
  )

newtype LoginForm r f = LoginForm (r (LoginFormRow f))

derive instance newtypeLoginForm :: Newtype (LoginForm r f) _

-- equivalent to { email :: Email, ... }
type LoginDataValidated = { | LoginFormRow F.OutputType }

type FormChildSlots =
  ( email :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , password :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , "register-button" :: H.Slot (Const Void) Button.Message Unit
  , "submit-button" :: H.Slot (Const Void) Button.Message Unit
  )


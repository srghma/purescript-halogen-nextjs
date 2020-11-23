module NextjsApp.PageImplementations.Login.Form.Types where

import NextjsApp.Data.Password (Password, PasswordError)
import NextjsApp.Data.InUseUsernameOrEmail (InUseUsernameOrEmail, InUseUsernameOrEmail__Error)
import Protolude

import Formless as F
import Halogen as H
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined

data UserAction
  = UserAction__RegisterButtonClick Button.Message

type LoginFormRow f =
  ( usernameOrEmail :: f InUseUsernameOrEmail__Error String InUseUsernameOrEmail
  , password :: f PasswordError String Password
  )

newtype LoginForm r f = LoginForm (r (LoginFormRow f))

derive instance newtypeLoginForm :: Newtype (LoginForm r f) _

-- equivalent to { email :: Email, ... }
type LoginDataValidated = { | LoginFormRow F.OutputType }

type FormChildSlots =
  ( usernameOrEmail :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , password :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , "register-button" :: H.Slot (Const Void) Button.Message Unit
  , "submit-button" :: H.Slot (Const Void) Button.Message Unit
  )


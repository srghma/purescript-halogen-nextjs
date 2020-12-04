module NextjsApp.PageImplementations.Register.Form.Types where

import NextjsApp.Data.Password (Password, PasswordError)
import NextjsApp.Data.NonUsedUsernameOrEmail (NonUsedUsernameOrEmail, NonUsedUsernameOrEmail__Error)
import Protolude

import Formless as F
import Halogen as H
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined

data UserAction
  = UserAction__RegisterButtonClick Button.Message

type RegisterFormRow f =
  ( usernameOrEmail :: f NonUsedUsernameOrEmail__Error String NonUsedUsernameOrEmail
  , password :: f PasswordError String Password
  )

newtype RegisterForm r f = RegisterForm (r (RegisterFormRow f))

derive instance newtypeRegisterForm :: Newtype (RegisterForm r f) _

-- equivalent to { email :: Email, ... }
type RegisterDataValidated = { | RegisterFormRow F.OutputType }

type FormChildSlots =
  ( usernameOrEmail :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , password :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , "register-button" :: H.Slot (Const Void) Button.Message Unit
  , "submit-button" :: H.Slot (Const Void) Button.Message Unit
  )


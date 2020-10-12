module NextjsApp.PageImplementations.Login.Form where

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
import NextjsApp.Data.Password

data UserAction
  = UserAction__RegisterButtonClick Button.Message

data EmailError
  = EmailError__Invalid
  | EmailError__InUse

data PasswordError
  = PasswordError__TooShort
  | PasswordError__TooLong

type LoginFormRow f =
  ( email    :: f EmailError    String Email
  , password :: f PasswordError String Password
  )

newtype LoginForm r f = LoginForm (r (LoginFormRow f))

derive instance newtypeLoginForm :: Newtype (LoginForm r f) _

-- equivalent to { name :: String, email :: V.Email, ... }
type LoginDataValidated = { | LoginFormRow F.OutputType }

type FormChildSlots =
  ( email :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , password :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , "register-button" :: H.Slot (Const Void) Button.Message Unit
  , "submit-button" :: H.Slot (Const Void) Button.Message Unit
  )

isEmailTaken :: Email -> Aff Boolean
isEmailTaken email = if Email.toString email == "taken@gmail.com" then pure true else pure false

formComponent ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  F.Component LoginForm (Const Void) FormChildSlots Unit LoginDataValidated m
formComponent = F.component (const formInput) formSpec
  where
    formInput :: F.Input' LoginForm m
    formInput =
      { initialInputs: Nothing -- same as: Just (F.wrapInputFields { name: "", age: "" })
      , validators: LoginForm
          { password: F.hoistFnE_ $ NonEmptyString.fromString >>>
            case _ of
                 Nothing -> Left $ PasswordError__TooShort
                 Just str ->
                        let
                          l = NonEmptyString.length str
                        in case unit of
                          _ | l < minPasswordLength -> Left $ PasswordError__TooShort
                            | l > maxPasswordLength -> Left $ PasswordError__TooLong
                            | otherwise -> Right $ Password str
          , email: F.hoistFnME_ $ Email.fromString >>>
            case _ of
              Nothing -> pure $ Left EmailError__Invalid
              Just email -> liftAff (isEmailTaken email) >>= if _ then pure $ Left EmailError__InUse else pure $ Right email
          }
      }

    formSpec :: forall input st . F.Spec LoginForm st (Const Void) UserAction FormChildSlots input LoginDataValidated m
    formSpec = F.defaultSpec { render = render, handleEvent = F.raiseResult, handleAction = handleAction }
      where

      handleAction ::
        UserAction ->
        F.HalogenM LoginForm st UserAction FormChildSlots LoginDataValidated m Unit
      handleAction =
        case _ of
             UserAction__RegisterButtonClick _ -> NextjsApp.Navigate.navigate NextjsApp.Route.Signup

      _password = SProxy :: SProxy "password"
      _email = SProxy :: SProxy "email"

      render :: F.PublicState LoginForm st -> F.ComponentHTML LoginForm UserAction FormChildSlots m
      render state =
        lmap (Halogen.Component.hoistSlot liftAff) $ HH.form_ -- TODO: lift?
          [ HH.slot
              (SProxy :: SProxy "email")
              unit
              TextField.Outlined.outlined
              ( TextField.Outlined.defaultConfig
                  { label = TextField.Outlined.LabelConfig__With { id: "email", labelText: "Email" }
                  , value = (F.getInput _email state.form :: String)
                  , additionalClassesRoot = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12 ]
                  }
              )
              (\(message :: TextField.Outlined.Message) ->
                case message of
                     TextField.Outlined.Message__Input string -> F.setValidate _email string
              )
          , HH.text case F.getError _email state.form of
              Nothing -> ""
              Just EmailError__InUse -> "Email is in use"
              Just EmailError__Invalid -> "Email is invalid"
          , HH.slot
              (SProxy :: SProxy "password")
              unit
              TextField.Outlined.outlined
              ( TextField.Outlined.defaultConfig
                  { label = TextField.Outlined.LabelConfig__With { id: "password", labelText: "Password" }
                  , value = (F.getInput _password state.form :: String)
                  , additionalClassesRoot = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12 ]
                  }
              )
              (\(message :: TextField.Outlined.Message) ->
                case message of
                     TextField.Outlined.Message__Input string -> F.setValidate _password string
              )
          , HH.text case F.getError _password state.form of
              Nothing -> ""
              Just PasswordError__TooShort -> "Password is too short"
              Just PasswordError__TooLong -> "Password is too long"
          , HH.div [ HP.class_ mdc_layout_grid__cell ] $ Array.singleton
              $ HH.div [ HP.class_ mdc_layout_grid__inner ]
                  [ HH.div
                      [ HP.classes [ mdc_layout_grid__cell, mdc_layout_grid____align_right ] ]
                      [ HH.slot
                          (SProxy :: SProxy "register-button")
                          unit
                          Button.button
                          { variant: Button.Text
                          , config: Button.defaultConfig { additionalClasses = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12_phone ] }
                          , content: [ HH.text "Register" ]
                          }
                          (inj (SProxy :: SProxy "userAction") <<< UserAction__RegisterButtonClick)
                      , HH.slot
                          (SProxy :: SProxy "submit-button")
                          unit
                          Button.button
                          { variant: Button.Raised
                          , config: Button.defaultConfig { additionalClasses = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12_phone ] }
                          , content: [ HH.text "Submit" ]
                          }
                          (\(message :: Button.Message) -> F.submit)
                      ]
                  ]
          ]


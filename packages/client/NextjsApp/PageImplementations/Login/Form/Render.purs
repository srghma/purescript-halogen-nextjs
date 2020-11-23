module NextjsApp.PageImplementations.Login.Form.Render where

import Protolude

import Data.Time.Duration (Milliseconds(..))
import Data.Variant (inj)
import Formless as F
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import NextjsApp.Data.InUseUsernameOrEmail (InUseUsernameOrEmail__Error(..))
import NextjsApp.Data.Password (PasswordError(..))
import NextjsApp.PageImplementations.Login.Css as NextjsApp.PageImplementations.Login.Css
import NextjsApp.PageImplementations.Login.Form.Types (FormChildSlots, LoginForm, UserAction(..))

prx ::
  { password :: SProxy "password"
  , usernameOrEmail :: SProxy "usernameOrEmail"
  }
prx = F.mkSProxies (F.FormProxy :: F.FormProxy LoginForm)

isInvalid :: forall t42 t43. F.FormFieldResult t43 t42 -> Boolean
isInvalid =
  case _ of
    F.Error _ -> true
    _ -> false

mkHelperText :: forall t23 t24 t26 t36.
  { errorToErrorText :: t24 -> String
  , id :: t26
  , result :: F.FormFieldResult t24 t23
  }
  -> Maybe
       { id :: t26
       , persistent :: Boolean
       , text :: String
       , validation :: Boolean
       }
mkHelperText = \config ->
   case config.result of
       F.Validating -> Just
         { id: config.id
         , persistent
         , text: "...Validating" -- TODO: slow down change using "on change: set opacity 0, change text, opacity 1"
         , validation: false
         }
       F.Error error -> Just
         { id: config.id
         , persistent
         , text: config.errorToErrorText error
         , validation: true
         }
       _ -> Nothing
  where
    persistent = true

render
  :: forall st
   . F.PublicState LoginForm st
  -> F.ComponentHTML LoginForm UserAction FormChildSlots Aff
render state =
  HH.div
    [ Halogen.HTML.Properties.ARIA.role "form" ]
    [ HH.slot
        prx.usernameOrEmail
        unit
        TextField.Outlined.outlined
        (
          let
            field = F.getField prx.usernameOrEmail state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With
              { id: "usernameOrEmail"
              , labelText: "Username / email"
              }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Login.Css.styles.input ]
            , invalid = isInvalid field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "usernameOrEmail-helper"
                , errorToErrorText:
                    case _ of
                         InUseUsernameOrEmail__Error__Empty -> "Username or email is empty"
                         InUseUsernameOrEmail__Error__NotInUse -> "Username or email is not found"
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.asyncSetValidate (Milliseconds 300.0) prx.usernameOrEmail string
        )
    , HH.slot
        prx.password
        unit
        TextField.Outlined.outlined
        (
          let
            field = F.getField prx.password state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With { id: "password", labelText: "Password" }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Login.Css.styles.input ]
            , invalid = isInvalid field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "password-helper"
                , errorToErrorText:
                    case _ of
                         PasswordError__TooShort -> "Password is too short"
                         PasswordError__TooLong -> "Password is too long"
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.setValidate prx.password string
        )
    , HH.div
      [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.buttons ]
      [ HH.slot
          (SProxy :: SProxy "submit-button")
          unit
          Button.button
          { variant: Button.Raised
          , config: Button.defaultConfig { additionalClasses = [ NextjsApp.PageImplementations.Login.Css.styles.buttons__button ] }
          , content: [ HH.text "Submit" ]
          }
          (\(_ :: Button.Message) -> spy "submit" (F.submit))
      , HH.slot
          (SProxy :: SProxy "register-button")
          unit
          Button.button
          { variant: Button.Text
          , config: Button.defaultConfig { additionalClasses = [ NextjsApp.PageImplementations.Login.Css.styles.buttons__button ] }
          , content: [ HH.text "Go to sign up" ]
          }
          (inj (SProxy :: SProxy "userAction") <<< UserAction__RegisterButtonClick)
      ]
    ]

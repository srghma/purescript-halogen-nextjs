module NextjsApp.PageImplementations.Login.Form.Render where

import Material.Classes.LayoutGrid
import NextjsApp.Data.InUseUsernameOrEmail
import NextjsApp.Data.Password
import NextjsApp.PageImplementations.Login.Form.Types
import Protolude

import Data.Array as Array
import Data.Either (Either(..))
import Data.Int as Int
import Data.Lens.Record as Lens
import Data.Maybe (Maybe(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Time.Duration (Milliseconds(..))
import Data.Variant (Variant, inj)
import Formless as F
import GraphQLClient as GraphQLClient
import Halogen as H
import Halogen.Component as Halogen.Component
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.PageImplementations.Login.Css as NextjsApp.PageImplementations.Login.Css
import NextjsApp.Route as NextjsApp.Route
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query

prx = F.mkSProxies (F.FormProxy :: _ LoginForm)

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
        ( TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With
              { id: "usernameOrEmail"
              , labelText: "Username / email"
              }
            , value = (F.getInput prx.usernameOrEmail state.form :: String)
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Login.Css.styles.input ]
            , helperText =
                let
                  id = "usernameOrEmail-helper"
                 in case F.getResult prx.usernameOrEmail state.form of
                     F.Validating -> Just
                       { id
                       , text: "...Validating"
                       , persistent: false
                       , validation: false
                       }
                     F.Error error -> Just
                       { id
                       , text:
                          case error of
                            InUseUsernameOrEmail__Error__Empty -> "Username or email is empty"
                            InUseUsernameOrEmail__Error__NotInUse -> "Username or email is not found"
                       , persistent: false
                       , validation: false
                       }
                     _ -> Nothing
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
        ( TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With { id: "password", labelText: "Password" }
            , value = (F.getInput prx.password state.form :: String)
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Login.Css.styles.input ]
            , helperText =
                case F.getError prx.password state.form of
                     Nothing -> Nothing
                     Just error -> Just
                      { id: "password-helper"
                      , text:
                        case error of
                          PasswordError__TooShort -> "Password is too short"
                          PasswordError__TooLong -> "Password is too long"
                      , persistent: false
                      , validation: true
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

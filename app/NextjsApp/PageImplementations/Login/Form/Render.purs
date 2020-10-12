module NextjsApp.PageImplementations.Login.Form.Render where

import NextjsApp.PageImplementations.Login.Form.Types
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

_password = SProxy :: SProxy "password"
_email = SProxy :: SProxy "email"

render :: forall st . F.PublicState LoginForm st -> F.ComponentHTML LoginForm UserAction FormChildSlots Aff
render state =
  HH.form_ -- TODO: lift?
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
        Just EmailError__Invalid -> "Email is invalid"
        Just (EmailError__InUse isConfirmed) -> "Email is in use" <> if isConfirmed then " and is confirmed" else ", but is not confirmed"
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

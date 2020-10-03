module NextjsApp.PageImplementations.Login (component) where

import Material.Classes.LayoutGrid
import Protolude

import Data.Array (singleton) as Array
import Data.Lens.Record (prop) as Lens
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Link as NextjsApp.Link
import NextjsApp.PageImplementations.Login.Css as Css
import NextjsApp.Route (Examples(..), Route(..))

type Query = Const Void

type Input = Unit

type Message = Void

type State =
  { email :: String
  , password :: String
  }

data Action
  = EmailChanged TextField.Outlined.Message
  | PasswordChanged TextField.Outlined.Message
  | RegisterButtonClick Button.Message
  | SubmitButtonClick Button.Message

type ChildSlots = ()

component :: H.Component Query Input Message AppM
component = H.hoist liftAff $
  H.mkComponent
    { initialState: const
      { email: ""
      , password: ""
      }
    , eval: H.mkEval $ H.defaultEval
      { handleAction =
          case _ of
               EmailChanged (TextField.Outlined.Message__Input x)    -> H.modify_ $ setEfficiently (Lens.prop (SProxy :: SProxy "email")) x
               PasswordChanged (TextField.Outlined.Message__Input x) -> H.modify_ $ setEfficiently (Lens.prop (SProxy :: SProxy "password")) x
               RegisterButtonClick Button.Message__Clicked -> traceM "RegisterButtonClick"
               SubmitButtonClick Button.Message__Clicked   -> traceM "SubmitButtonClick"
      }
    , render: \state ->
      HH.div
        [ HP.class_ mdc_layout_grid ]
        [ HH.div
          [ HP.class_ mdc_layout_grid__inner ]
          [ HH.img [ HP.classes [ mdc_layout_grid__cell, mdc_layout_grid__cell____align_middle, mdc_layout_grid__cell____span_3 ], HP.alt "logo", HP.src purescriptLogoSrc ]
          , HH.slot
            (SProxy :: SProxy "email")
            unit
            TextField.Outlined.outlined
              ( TextField.Outlined.defaultConfig
                { label = TextField.Outlined.LabelConfig__With { id: "email", labelText: "Email" }
                , value = state.email
                , additionalClassesRoot = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12 ]
                }
              )
            EmailChanged
          , HH.slot
            (SProxy :: SProxy "password")
            unit
            TextField.Outlined.outlined
              ( TextField.Outlined.defaultConfig
                { label = TextField.Outlined.LabelConfig__With { id: "password", labelText: "Password" }
                , value = state.password
                , additionalClassesRoot = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12 ]
                }
              )
            PasswordChanged
          , HH.div [ HP.class_ mdc_layout_grid__cell ] $ Array.singleton $ HH.div [ HP.class_ mdc_layout_grid__inner ]
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
                RegisterButtonClick
              , HH.slot
                (SProxy :: SProxy "submit-button")
                unit
                Button.button
                { variant: Button.Raised
                , config: Button.defaultConfig { additionalClasses = [ mdc_layout_grid__cell, mdc_layout_grid__cell____span_12_phone ] }
                , content: [ HH.text "Submit" ]
                }
                SubmitButtonClick
              ]
            ]
          ]
        ]
    }
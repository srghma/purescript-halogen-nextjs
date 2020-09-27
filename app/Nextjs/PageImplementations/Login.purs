module Nextjs.PageImplementations.Login (component) where

import Protolude

import Data.Lens.Record (prop) as Lens
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import Nextjs.AppM (AppM)
import Nextjs.Blocks.PurescriptLogo (purescriptLogoSrc)
import Nextjs.Link as Nextjs.Link
import Nextjs.Route (Examples(..), Route(..))
import Nextjs.PageImplementations.Login.Css as Css

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
        [ HP.class_ Css.styles.root
        ]
        [ HH.img [ HP.class_ Css.styles.logo, HP.alt "logo", HP.src purescriptLogoSrc ]
        , HH.slot
          (SProxy :: SProxy "email")
          unit
          TextField.Outlined.outlined
            ( TextField.Outlined.defaultConfig
              { label = TextField.Outlined.LabelConfig__With { id: "email", labelText: "Email" }
              , value = state.email
              , fullwidth = true
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
              , fullwidth = true
              }
            )
          PasswordChanged
        , HH.div
          [ HP.class_ Css.styles.buttons ]
          [ HH.slot (SProxy :: SProxy "register-button") unit Button.button { variant: Button.Text, config: Button.defaultConfig, content: [ HH.text "Register" ] } RegisterButtonClick
          , HH.slot (SProxy :: SProxy "submit-button") unit Button.button { variant: Button.Raised, config: Button.defaultConfig, content: [ HH.text "Submit" ] } SubmitButtonClick
          ]
        ]
    }

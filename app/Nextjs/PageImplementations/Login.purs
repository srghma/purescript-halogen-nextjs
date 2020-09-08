module Nextjs.PageImplementations.Login (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import Nextjs.AppM (AppM)
import Nextjs.Link as Nextjs.Link
import Nextjs.Route (Examples(..), Route(..))
import HalogenMWC.TextField as TextField
import HalogenMWC.Button as Button

type Query = Const Void

type Input = Unit

type Message = Void

type State =
  { email :: String
  , password :: String
  }

type Action = Void

type ChildSlots = ()

component :: H.Component Query Input Message AppM
component =
  H.mkComponent
    { initialState: const
      { email: ""
      , password: ""
      }
    , eval: H.mkEval $ H.defaultEval
    , render: \state ->
      HH.div_
        [ HH.text "Login"
        , traceId $ TextField.filled TextField.defaultConfig
        -- | , TextField.filled (TextField.defaultConfig { label = Just "email", value = Just state.email })
        -- | , TextField.filled (TextField.defaultConfig { label = Just "password", value = Just state.password })
        -- | , Button.button Button.Text Button.defaultConfig [ HH.text "Register" ]
        -- | , Button.button Button.Raised Button.defaultConfig [ HH.text "Submit" ]
        ]
    }

module Worker.Jobs.SendVerificationEmailForUserEmail where

import Foreign
import Protolude

import Data.Argonaut (Json, JsonDecodeError)
import Data.Argonaut as Argonaut
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Foreign as Foreign
import GraphileWorker (JobHelpers)
import Halogen.HTML as HH
import HalogenVdomStringRendererRaw as HalogenVdomStringRendererRaw
import Mjml as Mjml
import MjmlHalogenElements as MjmlHalogenElements
import Nodemailer as Nodemailer

html :: forall w i . Int -> HH.HTML w i
html id =
  MjmlHalogenElements.mjml_
  [ MjmlHalogenElements.mj_body_
    [ MjmlHalogenElements.mj_section_
      [ MjmlHalogenElements.mj_column_
        [ MjmlHalogenElements.mj_text_ [ HH.text $ "Hello World! " <> show id ]
        ]
      ]
    ]
  ]

newtype Input = Input
  { id :: String
  }

derive instance newtypeInput :: Newtype Input _
derive instance genericInput :: Generic Input _

job :: Json -> JobHelpers -> Effect Unit
job json helpers = do
  (input :: Input) <- genericDecodeJson json
    # either (throwError <<< error <<< Argonaut.printJsonDecodeError) pure

  emailBody <-
    Mjml.mjml2html
    (HalogenVdomStringRendererRaw.renderHtmlWithRawTextSupport (html (unwrap input).id)
    )
    Mjml.defaultMjmlOptions

  launchAff_ do
     transportConfig <- Nodemailer.createTestAccount
     transporter <- liftEffect $ Nodemailer.createTransporter transportConfig
     Nodemailer.sendMail_

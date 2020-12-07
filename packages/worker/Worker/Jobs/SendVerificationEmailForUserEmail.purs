-- Based on
-- https://github.com/graphile/bootstrap-react-apollo/blob/master/tasks/sendVerificationEmailForUserEmail.js

module Worker.Jobs.SendVerificationEmailForUserEmail where

import Foreign
import Protolude
import Worker.EmailUI

import Data.Argonaut (Json, JsonDecodeError)
import Data.Argonaut as Argonaut
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Array as Array
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..), Row3(..), fromSQLValue)
import Database.PostgreSQL as PostgreSQL
import Foreign as Foreign
import GraphileWorker (JobHelpers, runWithPgClient)
import GraphileWorker as GraphileWorker
import Halogen.HTML (prop, PropName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenVdomStringRendererRaw as HalogenVdomStringRendererRaw
import Mjml as Mjml
import MjmlHalogenElements as MjmlHalogenElements
import NodeMailer as NodeMailer
import PostgreSQLExtra as PostgreSQLExtra

html
  :: forall w i
   . UserDataFromDb
  -> HH.HTML w i
html (UserDataFromDb user) =
  MjmlHalogenElements.mjml_
  [ MjmlHalogenElements.mj_body_
    [ MjmlHalogenElements.mj_section
      [ prop (PropName "full-width") "full-width" ]
      [ MjmlHalogenElements.mj_column_
        [ MjmlHalogenElements.mj_text_
          [ HH.text "Dear "
          , HH.strong_ [ HH.text (fromMaybe user.email user.name) ]
          , HH.text ","
          ]
        , break
        , MjmlHalogenElements.mj_text_
          [ HH.text "Thanks for your interest in"
          , HH.strong_ [ HH.text "Nextjs" ]
          , HH.text "."
          ]
        , MjmlHalogenElements.mj_text [ prop (PropName "padding-bottom") "10px" ]
          [ HH.text "Click the link below to verify your email and get started using your"
          , HH.strong_ [ HH.text "Nextjs" ]
          , HH.text "account."
          ]
        , MjmlHalogenElements.mj_text [ prop (PropName "padding-bottom") "10px" ]
          [ link_to_styled "Get started" user.verificationToken
          , HH.strong_ [ HH.text "Nextjs" ]
          , HH.text "account."
          ]
        ]
      ]
    ]
  ]

newtype Input = Input
  { id :: String
  }

derive instance newtypeInput :: Newtype Input _
derive instance genericInput :: Generic Input _

newtype UserDataFromDb
  = UserDataFromDb
    { name :: Maybe String
    , email :: String
    , isVerified :: Boolean
    , verificationToken :: String
    }

derive instance newtypeUserDataFromDb :: Newtype UserDataFromDb _

instance userDataFromDbFromSQLRow :: FromSQLRow UserDataFromDb where
  fromSQLRow
    [ v_name
    , v_email
    , v_isVerified
    , v_verificationToken
    ] = ado
      name <- fromSQLValue v_name
      email <- fromSQLValue v_email
      isVerified <- fromSQLValue v_isVerified
      verificationToken  <- fromSQLValue v_verificationToken
      in UserDataFromDb
        { name
        , email
        , isVerified
        , verificationToken
        }
  fromSQLRow xs = Left $ "Row has " <> show (Array.length xs) <> " fields."

job ::
  { json :: Json
  , connection :: Connection
  , transporter :: NodeMailer.Transporter
  } ->
  Aff Unit
job
  { json
  , connection
  , transporter
  } = do
  (input :: Input) <- genericDecodeJson json
    # either (throwError <<< error <<< Argonaut.printJsonDecodeError) pure

  (userData :: UserDataFromDb) <-
    PostgreSQLExtra.queryHeadOrThrow connection
      ( Query """
      SELECT
        t_user_email.name AS name,
        t_user_email.email AS email,
        t_user_email.is_verified AS is_verified,
        t_user_email_secret.verification_token AS verification_token
      FROM app_public.user_emails AS t_user_email
        JOIN app_private.user_email_secrets AS t_user_email_secret
        ON t_user_email.id = t_user_email_secret.user_email_id
      WHERE t_user_email.id = $1
      """
      )
      (Row1 (unwrap input).id)

  emailBody <- liftEffect $
    Mjml.mjml2html
    (HalogenVdomStringRendererRaw.renderHtmlWithRawTextSupport (html userData)
    )
    Mjml.defaultMjmlOptions

  messageInfo <-
    NodeMailer.sendMail
    transporter
    { from: "purescript-nextjs@gmail.com"
    , to: [ "useremail@gmail.com" ]
    , cc: []
    , bcc: []
    , subject: "Verify yourself"
    , text: emailBody
    , attachments: []
    }

  traceM messageInfo

  PostgreSQLExtra.executeOrThrow connection
    ( Query """
    UPDATE app_private.user_email_secrets AS t_user_email_secret
    SET verification_email_sent_at = now()
    WHERE t_user_email_secret.user_email_id = $1
    """
    )
    (Row1 (unwrap input).id)

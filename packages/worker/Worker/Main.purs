module Worker.Main where

import Protolude
import Worker.JobIds

import Data.Argonaut (Json, JsonDecodeError)
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..), Row3(..), fromSQLValue)
import Database.PostgreSQL as PostgreSQL
import Database.PostgreSQL.Pool as PostgreSQL
import GraphileWorker (JobHelpers, runWithPgClient)
import GraphileWorker (JobHelpers, runWithPgClient)
import GraphileWorker as GraphileWorker
import NodeMailer (Transporter)
import NodeMailer as NodeMailer
import Worker.Config as Config
import Worker.Jobs.SendVerificationEmailForUserEmail as Worker.Jobs.SendVerificationEmailForUserEmail

main :: Effect Unit
main = launchAff_ do
  config <- liftEffect Config.config

  pgPool <- liftEffect $ PostgreSQL.new
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just $ config.databaseOwnerPassword
    , port:              config.databasePort
    , user:              Just "app_owner"
    }

  transportConfig <- NodeMailer.createTestAccount

  traceM transportConfig

  transporter <- liftEffect $ NodeMailer.createTransporter transportConfig

  let
    mkEmailJob ::
      ( { json :: Json
        , connection :: Connection
        , transporter :: NodeMailer.Transporter
        } ->
        Aff Unit
      ) ->
      Json ->
      JobHelpers ->
      Aff Unit
    mkEmailJob f json helpers = runWithPgClient helpers.withPgClient \connection -> f { json, connection, transporter }

    taskList :: JobIds (Json -> JobHelpers -> Aff Unit)
    taskList =
      { "JOB__SEND_EMAIL": undefined
      , "JOB__SEND_PASSWORD_RESET_EMAIL": undefined
      , "JOB__SEND_VERIFICATION_EMAIL_FOR_USER_EMAIL": mkEmailJob Worker.Jobs.SendVerificationEmailForUserEmail.job
      }

  GraphileWorker.run
    { pgPool
    , taskList
    }

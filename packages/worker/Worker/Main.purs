module Worker.Main where

import Protolude
import Worker.Config as Config
import Worker.JobIds
import Worker.Jobs.SendVerificationEmailForUserEmail as Worker.Jobs.SendVerificationEmailForUserEmail
import Data.Argonaut (Json, JsonDecodeError)
import GraphileWorker (JobHelpers, runWithPgClient)
import GraphileWorker as GraphileWorker
import Database.PostgreSQL as PostgreSQL
import Database.PostgreSQL.Pool as PostgreSQL

taskList :: JobIds (Json -> JobHelpers -> Effect Unit)
taskList =
  { "JOB__SEND_EMAIL": undefined
  , "JOB__SEND_PASSWORD_RESET_EMAIL": undefined
  , "JOB__SEND_VERIFICATION_EMAIL_FOR_USER_EMAIL": Worker.Jobs.SendVerificationEmailForUserEmail.job
  }

main :: Effect Unit
main = do
  config <- Config.config

  pgPool <- PostgreSQL.new
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just $ config.databaseOwnerPassword
    , port:              config.databasePort
    , user:              Just "app_owner"
    }

  launchAff_ $ GraphileWorker.run
    { pgPool
    , taskList
    }

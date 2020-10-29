module ApiServer.DatabasePools where

import Protolude
import Database.PostgreSQL

createPools
  :: { databaseName :: String
     , databaseHost :: String
     , databasePort :: Maybe Int
     -- This pool runs as the database owner, so it can do anything.
     , ownerUser :: String
     , ownerPassword :: String
     -- This pool runs as the unprivileged user, it's what PostGraphile uses.
     , authenticatorUser :: String
     , authenticatorPassword :: String
     }
  -> Effect
     { rootPgPool :: Pool
     , authPgPool :: Pool
     }
createPools config = do
  rootPgPool <- newPool
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just config.ownerPassword
    , port:              config.databasePort
    , user:              Just config.ownerUser
    }
  authPgPool <- newPool
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just config.authenticatorPassword
    , port:              config.databasePort
    , user:              Just config.authenticatorUser
    }
  pure { rootPgPool, authPgPool }


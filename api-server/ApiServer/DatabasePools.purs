module ApiServer.DatabasePools where

import Database.PostgreSQL
import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString

createPools
  :: { databaseName :: String
     , databaseHost :: String
     , databasePort :: Maybe Int

     -- This pool runs as the database owner, so it can do anything.
     , databaseOwnerUser :: String
     , databaseOwnerPassword :: NonEmptyString

     -- This pool runs as the unprivileged user, it's what PostGraphile uses.
     , databaseAuthenticatorUser :: String
     , databaseAuthenticatorPassword :: NonEmptyString
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
    , password:          Just $ NonEmptyString.toString config.databaseOwnerPassword
    , port:              config.databasePort
    , user:              Just config.databaseOwnerUser
    }
  authPgPool <- newPool
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just $ NonEmptyString.toString config.databaseAuthenticatorPassword
    , port:              config.databasePort
    , user:              Just config.databaseAuthenticatorUser
    }
  pure { rootPgPool, authPgPool }


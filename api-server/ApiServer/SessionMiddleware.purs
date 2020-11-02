module ApiServer.SessionMiddleware where

import NextjsApp.NodeEnv
import Node.Express.Types
import Protolude

import ConnectPgSimple as ConnectPgSimple
import Data.Time.Duration (Days(..))
import Data.Time.Duration as Duration
import Database.PostgreSQL (Pool)
import ExpressSession (ExpiresCookieCalculation(..), ExpressSessionStore, SameSite(..), Unset(..))
import ExpressSession as ExpressSession

sessionMiddleware
  :: { isProduction :: Boolean
     , rootPgPool :: Pool
     , secret :: String
     }
   -> Effect Middleware
sessionMiddleware { isProduction, rootPgPool, secret } = do
  expressSession <- ExpressSession.expressSession

  let (store :: ExpressSessionStore) =
        ConnectPgSimple.mkExpressSessionStore
        expressSession
        { pool: rootPgPool
        , schemaName: "app_private"
        , tableName: "user_sessions"
        }

  -- https://github.com/graphile/bootstrap-react-apollo/blob/fbeab7b9c2/server/middleware/installSession.js
  pure $ ExpressSession.createMiddleware expressSession
    { cookie:
      { path: "/"
      , httpOnly: isProduction
      , secure: isProduction
      , maxAgeOrExpires: Just $ ExpiresCookieCalculation__MaxAge $ Duration.fromDuration $ Days 3.0
      , sameSite: SameSite__Strict
      }
    , genid: Nothing
    , name: "connect.sid" -- default value
    , proxy: Nothing
    , saveUninitialized: false
    , resave: false
    , rolling: true
    , store
    , secret
    , unset: Unset__Destroy
    }

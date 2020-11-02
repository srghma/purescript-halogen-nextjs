module ConnectPgSimple where

import ExpressSession
import Protolude

import Data.Function as Data.Function
import Data.Function.Uncurried (Fn3)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.Time.Duration (Milliseconds(..))
import Database.PostgreSQL (Pool)
import Hyper.Cookies (maxAge)
import Node.Express.Types (Request)
import Node.HTTP.Client (Response)
import Unsafe.Coerce (unsafeCoerce)

type Config =
  { pool :: Pool
  , schemaName :: String
  , tableName :: String
  -- | , ttl
  }

foreign import mkExpressSessionStore :: ExpressSession -> Config -> ExpressSessionStore

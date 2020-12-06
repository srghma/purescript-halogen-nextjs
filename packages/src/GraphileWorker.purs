module GraphileWorker where

import Control.Promise
import Data.Exists
import Data.Function.Uncurried
import Data.JSDate
import Data.Nullable
import Database.PostgreSQL
import Effect.Uncurried
import Foreign.Object
import Protolude

import Control.Promise as Promise
import Foreign (Foreign)
import Unsafe.Coerce (unsafeCoerce)

data GraphileWorkerRunner

type Logger =
  { error :: EffectFn1 String Unit
  , warn  :: EffectFn1 String Unit
  , info  :: EffectFn1 String Unit
  , debug :: EffectFn1 String Unit
  }

type Job =
  { id              :: String
  , queue_name      :: Nullable String
  , task_identifier :: String
  , payload         :: Foreign
  , priority        :: Number
  , run_at          :: JSDate
  , attempts        :: Number
  , max_attempts    :: Number
  , last_error      :: Nullable String
  , created_at      :: JSDate
  , updated_at      :: JSDate
  , key             :: Nullable String
  , revision        :: Number
  , locked_at       :: Nullable JSDate
  , locked_by       :: Nullable String
  , flags           :: Nullable (Object Boolean)
  }

type TaskSpec =
  { queueName :: Nullable String
  , runAt :: Nullable JSDate
  , priority :: Nullable Number
  , maxAttempts :: Nullable Number
  , jobKey :: Nullable String
  , flags :: Nullable (Array String)
  }

type AddJobFunction = EffectFn3 String (Nullable Foreign) (Nullable TaskSpec) (Promise Job)

type WithPgClientImplementation a = EffectFn1 (EffectFn1 Connection (Promise a)) (Promise a)

data WithPgClient

type JobHelpers =
  { logger :: Logger
  , withPgClient :: WithPgClient
  , addJob :: AddJobFunction
  , job :: Job
  }

runWithPgClient :: forall a .
  WithPgClient ->
  (Connection -> Aff a) ->
  Aff a
runWithPgClient withPgClientBoxed f = Promise.toAffE $ runEffectFn1 withPgClient $ mkEffectFn1 \connection -> Promise.fromAff $ f connection
  where
  withPgClient :: WithPgClientImplementation a
  withPgClient = unsafeCoerce withPgClientBoxed

foreign import _run ::
  EffectFn1
  { connectionString :: String
  , concurrency :: Int
  , noHandleSignals :: Boolean
  , pollInterval :: Int
  , taskList :: Object (EffectFn2 Foreign JobHelpers Unit)
  }
  (Promise GraphileWorkerRunner)

foreign import _quickAddJob ::
  EffectFn3
  { connectionString :: String
  }
  String
  Foreign
  (Promise Unit)

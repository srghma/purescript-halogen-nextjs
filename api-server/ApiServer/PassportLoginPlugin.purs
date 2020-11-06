module ApiServer.PassportLoginPlugin where

import Control.Promise
import Effect.Uncurried
import Postgraphile
import Protolude

import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Database.PostgreSQL (Pool)

-- TypeDefs

type RegisterInput =
  { username  :: String
  , email     :: String
  , password  :: String
  , name      :: Nullable String
  , avatarUrl :: Nullable String
  }

type RegisterPayload =
  { user :: User
  }

type LoginInput =
  { username :: String
  , password :: String
  }

type LoginPayload =
  { user :: User
  }

--------------------------

type User =
  { username          :: String
  , email             :: String
  , email_is_verified :: String
  , name              :: String
  , avatar_url        :: String
  , password          :: String
  }

type ContextInjectedByUsRow r =
  ( rootPgPool :: Pool
  , login :: User -> Effect Unit
  | r )

type ContextInjectedByPostgraphileRow r =
  ( pgClient :: Pool
  | r )

type Context = Record (ContextInjectedByUsRow + ContextInjectedByPostgraphileRow + ())

data FnArgMutation
data FnArgResolveInfo

data SqlFragment
data QueryBuilder
data SelectGraphQLResultFromTable__Result

type MutationsImplementation =
  { register ::
      EffectFn5
      FnArgMutation
      { input :: RegisterInput
      }
      Context
      FnArgResolveInfo
      { selectGraphQLResultFromTable ::
        EffectFn2
        SqlFragment
        (EffectFn2 String QueryBuilder Unit)
        (Promise SelectGraphQLResultFromTable__Result)
      }
      (Promise { "data" :: SelectGraphQLResultFromTable__Result })
  , login ::
      EffectFn5
      FnArgMutation
      { input :: LoginInput
      }
      Context
      FnArgResolveInfo
      { selectGraphQLResultFromTable ::
        EffectFn2
        SqlFragment
        (EffectFn2 String QueryBuilder Unit)
        (Promise SelectGraphQLResultFromTable__Result)
      }
      (Promise { "data" :: SelectGraphQLResultFromTable__Result })
  }

data MakeExtendSchemaPlugin__BuildArg

type MkResolvers = MakeExtendSchemaPlugin__BuildArg -> { "Mutation" :: MutationsImplementation }

foreign import mkPassportLoginPlugin :: MkResolvers -> PostgraphileAppendPlugin

passportLoginPlugin :: PostgraphileAppendPlugin
passportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { register: mkEffectFn5 \mutation args context resolveInfo { selectGraphQLResultFromTable } -> undefined
    , login: mkEffectFn5 \mutation args context resolveInfo { selectGraphQLResultFromTable } -> undefined
    }
  }

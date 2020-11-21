module ApiServer.PassportLoginPlugin where

import Control.Promise
import Effect.Uncurried
import Postgraphile
import Protolude

import Control.Promise as Promise
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Database.PostgreSQL (Pool)

-- TypeDefs

type WebRegisterInput =
  { username  :: String
  , email     :: String
  , password  :: String
  , name      :: Nullable String
  , avatarUrl :: Nullable String
  }

type WebRegisterPayload =
  { user :: User
  }

type WebLoginInput =
  { username :: String
  , password :: String
  }

type WebLoginPayload =
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

type FnArgHelpers =
  { selectGraphQLResultFromTable ::
    EffectFn2
    SqlFragment
    (EffectFn2 String QueryBuilder Unit)
    (Promise SelectGraphQLResultFromTable__Result)
  }

type MutationsImplementation =
  { webRegister ::
      EffectFn5
      FnArgMutation
      { input :: WebRegisterInput
      }
      Context
      FnArgResolveInfo
      FnArgHelpers
      (Promise { "data" :: SelectGraphQLResultFromTable__Result })
  , webLogin ::
      EffectFn5
      FnArgMutation
      { input :: WebLoginInput
      }
      Context
      FnArgResolveInfo
      FnArgHelpers
      (Promise { "data" :: SelectGraphQLResultFromTable__Result })
  }

data MakeExtendSchemaPlugin__BuildArg

type MkResolvers = MakeExtendSchemaPlugin__BuildArg -> { "Mutation" :: MutationsImplementation }

foreign import mkPassportLoginPlugin :: MkResolvers -> PostgraphileAppendPlugin

passportLoginPlugin :: PostgraphileAppendPlugin
passportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { webRegister: mkEffectFn5 \mutation args context resolveInfo helpers -> undefined
    , webLogin: mkEffectFn5 \mutation args context resolveInfo helpers -> Promise.fromAff do
       traceM { mutation, args, context, resolveInfo, helpers }
       pure undefined
    }
  }

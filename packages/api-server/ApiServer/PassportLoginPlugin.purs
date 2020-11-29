module ApiServer.PassportLoginPlugin where

import Control.Promise
import Effect.Uncurried
import Postgraphile
import Protolude

import Control.Monad.Except (Except)
import Control.Promise as Promise
import Data.List.NonEmpty as NonEmptyList
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Database.PostgreSQL (Pool)
import Database.PostgreSQL as PostgreSQL
import Foreign (F, Foreign, MultipleErrors)
import Foreign as Foreign
import Foreign.Index as Foreign

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

type WebLoginPayload =
  { user :: User
  }

--------------------------

newtype User = User
  { username          :: String
  , email             :: String
  , email_is_verified :: String
  , name              :: String
  , avatar_url        :: String
  , password          :: String
  }

type ContextInjectedByUsRow r =
  ( ownerPgPool :: Pool
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
      { input :: Foreign
      }
      Context
      FnArgResolveInfo
      FnArgHelpers
      (Promise { "data" :: SelectGraphQLResultFromTable__Result })
  , webLogin ::
      EffectFn5
      FnArgMutation
      { input :: Foreign
      }
      Context
      FnArgResolveInfo
      FnArgHelpers
      (Promise { "data" :: SelectGraphQLResultFromTable__Result })
  }

data MakeExtendSchemaPlugin__BuildArg

type MkResolvers = MakeExtendSchemaPlugin__BuildArg -> { "Mutation" :: MutationsImplementation }

foreign import mkPassportLoginPlugin :: MkResolvers -> PostgraphileAppendPlugin

type WebLoginInput =
  { username :: String
  , password :: String
  }

decodeWebLoginInput :: Foreign -> Except MultipleErrors WebLoginInput
decodeWebLoginInput value = ado
  username <- value Foreign.! "username" >>= Foreign.readString
  password <- value Foreign.! "password" >>= Foreign.readString

  in
    { username
    , password
    }

throwPgError e = do
  traceM { e }
  throwError <<< error <<< (\pgError -> "PgError: " <> show pgError) $ e

passportLoginPlugin :: PostgraphileAppendPlugin
passportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { webRegister: mkEffectFn5 \mutation args context resolveInfo helpers -> undefined
    , webLogin: mkEffectFn5 \mutation args context resolveInfo helpers -> Promise.fromAff do
       -- | traceM { mutation, args, context, resolveInfo, helpers }
       (input ::WebLoginInput) <- runExcept (decodeWebLoginInput args.input)
          # either (throwError <<< error <<< Foreign.renderForeignError <<< NonEmptyList.head) pure

       traceM { input }

       PostgreSQL.withConnection context.ownerPgPool $ either throwPgError \connection -> do
          let q =
                """
                select users.* from app_private.login($1, $2) users
                """

          traceM { q }

          (result :: Maybe (Maybe Foreign)) <-
              PostgreSQL.scalar connection
              ( PostgreSQL.Query q
              )
              (PostgreSQL.Row2 input.username input.password)
              >>= either throwPgError pure

          traceM { result }

          pure unit

          -- | const {
          -- |   rows: [user],
          -- | } = await rootPgPool.query(
          -- |   `select users.* from app_private.login($1, $2) users where not (users is null)`,
          -- |   [username, password]
          -- | );

       pure undefined
    }
  }

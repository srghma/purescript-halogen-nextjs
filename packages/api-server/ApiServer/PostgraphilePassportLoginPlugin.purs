module ApiServer.PostgraphilePassportLoginPlugin where

import Control.Promise
import Effect.Uncurried
import Postgraphile
import Protolude

import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed
import Control.Monad.Except (Except)
import Control.Promise as Promise
import Data.Function.Uncurried
import Data.List.NonEmpty as NonEmptyList
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Database.PostgreSQL (Connection, Pool, Row4(..))
import Database.PostgreSQL as PostgreSQL
import Effect.Exception.Unsafe (unsafeThrowException)
import Foreign (F, Foreign, MultipleErrors)
import Foreign as Foreign
import Foreign.Index as Foreign
import Node.Express.Passport as Passport
import Node.Express.Types (Request)
import Unsafe.Coerce (unsafeCoerce)

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
  , req :: Request
  | r )

type ContextInjectedByPostgraphileRow r =
  ( pgClient :: Connection
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

data FragmentMaker
data SqlValueFn

foreign import appPublicUsersFragment :: FragmentMaker -> SqlFragment
foreign import mkSelectGraphQLResultFromTable ::
  Fn2
  String
  { fragment :: FragmentMaker, value :: SqlValueFn }
  (EffectFn2 String QueryBuilder Unit)

foreign import mkPassportLoginPlugin ::
  ( { pgSql ::
      { fragment :: FragmentMaker
      , value :: SqlValueFn
      }
    }
  ->
    { "Mutation" :: MutationsImplementation
    }
  )
  -> PostgraphileAppendPlugin

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

postgraphilePassportLoginPlugin :: PostgraphileAppendPlugin
postgraphilePassportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { webRegister: mkEffectFn5 \mutation args context resolveInfo helpers -> unsafeThrowException $ error "webRegister"
    , webLogin: mkEffectFn5 \mutation args context resolveInfo helpers -> Promise.fromAff do
       -- | traceM { mutation, args, context, resolveInfo, helpers }
       traceM { context }

       (input ::WebLoginInput) <- runExcept (decodeWebLoginInput args.input)
          # either (throwError <<< error <<< Foreign.renderForeignError <<< NonEmptyList.head) pure

       traceM { input }

       user <- PostgreSQL.withConnection context.ownerPgPool $ either throwPgError \connection -> do
          (result :: Array (Row4 String String (Maybe String) (Maybe String))) <-
            PostgreSQL.query connection
            ( PostgreSQL.Query
              """
              select
                users.id,
                users.username,
                users.name,
                users.avatar_url
              from app_private.web_login($1, $2) users
              where not (users is null)
              """
            )
            (PostgreSQL.Row2 input.username input.password)
            >>= either throwPgError pure

          traceM { result }

          user <-
            case result of
                [] -> throwError $ error "Invalid password"
                [Row4 id username name avatar_url] -> pure { id, username, name, avatar_url }
                _ -> throwError $ error "Expected exactly 1 array elem"

          traceM { user }

          pure user

       PostgreSQL.execute context.pgClient
          ( PostgreSQL.Query
            """
            select set_config($1, $2, true);
            """
          )
          (PostgreSQL.Row2 "jwt.claims.user_id" user.id)
          >>= maybe (pure unit) throwPgError

       ApiServer.PassportMethodsFixed.passportMethods.login
         (ApiServer.PassportMethodsFixed.UserUUID user.id)
         Passport.defaultLoginOptions
         context.req
         >>= maybe (pure unit) throwError

       output <- Promise.toAffE $
         runEffectFn2
         helpers.selectGraphQLResultFromTable
         (appPublicUsersFragment build.pgSql.fragment )
         (runFn2 mkSelectGraphQLResultFromTable user.id build.pgSql)

       traceM { output }

       pure { "data": output }
    }
  }

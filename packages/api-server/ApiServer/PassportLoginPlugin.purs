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
import Database.PostgreSQL (Connection, Pool, Row4(..))
import Database.PostgreSQL as PostgreSQL
import Effect.Exception.Unsafe (unsafeThrowException)
import Foreign (F, Foreign, MultipleErrors)
import Foreign as Foreign
import Foreign.Index as Foreign
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
  , login :: User -> Effect Unit
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

fragmentMakerAsFunc :: FragmentMaker -> String -> SqlFragment
fragmentMakerAsFunc = unsafeCoerce

foreign import mkSelectGraphQLResultFromTable :: String -> EffectFn2 String QueryBuilder Unit

foreign import mkPassportLoginPlugin ::
  ( { pgSql ::
      { fragment :: FragmentMaker
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

passportLoginPlugin :: PostgraphileAppendPlugin
passportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { webRegister: mkEffectFn5 \mutation args context resolveInfo helpers -> unsafeThrowException $ error "webRegister"
    , webLogin: mkEffectFn5 \mutation args context resolveInfo helpers -> Promise.fromAff do
       -- | traceM { mutation, args, context, resolveInfo, helpers }

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

       output <- Promise.toAffE $
         runEffectFn2
         helpers.selectGraphQLResultFromTable
         (fragmentMakerAsFunc build.pgSql.fragment "app_public.users")
         (mkSelectGraphQLResultFromTable user.id)

       PostgreSQL.execute context.pgClient
          ( PostgreSQL.Query
            """
            select set_config($1, $2, true);
            """
          )
          (PostgreSQL.Row2 "jwt.claims.user_id" user.id)
          >>= maybe (pure unit) throwPgError

       pure { "data": output }
    }
  }

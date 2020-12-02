module ApiServer.PostgraphilePassportLoginPlugin where

import ApiServerExceptions.PostgraphilePassportLoginPlugin
import Control.Promise
import Data.Function.Uncurried
import Effect.Uncurried
import Postgraphile
import Protolude

import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed
import Control.Monad.Except (Except)
import Control.Promise as Promise
import Data.List.NonEmpty as NonEmptyList
import Data.Newtype (over)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Database.PostgreSQL (Connection, PGError, Pool, Row4(..))
import Database.PostgreSQL as PostgreSQL
import Effect.Aff (bracket)
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
    (Promise (Array SelectGraphQLResultFromTable__Result))
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

-- | throwPgError e = do
-- |   -- | traceM { e }
-- |   throwError <<< error <<< (\pgError -> "PgError: " <> show pgError) $ e

bracketEither ∷ ∀ a b eAcc eRes . Aff (Either eAcc a) → (a → Aff Unit) → (a → Aff (Either eRes b)) → Aff (Either eAcc (Either eRes b))
bracketEither acquire completed run =
  bracket
  acquire
  ( case _ of
         Left eAcc -> pure unit
         Right a -> completed a
  )
  ( case _ of
         Left e -> pure $ Left e
         Right a -> map Right (run a)
  )

withConnectionEither ::
  forall a e.
  Pool ->
  (Connection -> Aff (Either e a)) ->
  Aff (Either PGError (Either e a))
withConnectionEither p k = bracketEither (PostgreSQL.connect p) cleanup run
  where
  cleanup { done } = liftEffect done
  run { connection } = k connection

withConnectionExceptT ::
  forall a e.
  Pool ->
  (PGError -> e) ->
  (Connection -> ExceptT e Aff a) ->
  ExceptT e Aff a
withConnectionExceptT pool toError action =
  ExceptT $
  (map $ either (toError >>> Left) identity) $
  withConnectionEither pool (runExceptT <<< action)

mapErrorExceptT :: forall m e e' a . Functor m => (e -> e') -> ExceptT e m a -> ExceptT e' m a
mapErrorExceptT f = over ExceptT $ map (lmap f)

maybeToExceptT :: forall e m . Functor m => m (Maybe e) -> ExceptT e m Unit
maybeToExceptT = ExceptT <<< map (maybe (Right unit) Left)

postgraphilePassportLoginPlugin :: PostgraphileAppendPlugin
postgraphilePassportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { webRegister: mkEffectFn5 \mutation args context resolveInfo helpers -> unsafeThrowException $ error "webRegister"
    , webLogin:
     let
        decodeWebLoginInput :: Foreign -> Except MultipleErrors WebLoginInput
        decodeWebLoginInput value = ado
          username <- value Foreign.! "username" >>= Foreign.readString
          password <- value Foreign.! "password" >>= Foreign.readString
          in
            { username
            , password
            }

        runExceptWebLoginExceptions :: forall a . ExceptT WebLoginExceptionsServer Aff a -> Effect (Promise a)
        runExceptWebLoginExceptions = runExceptT >>> (_ >>= either logAndThrowError pure) >>> Promise.fromAff
          where
            logAndThrowError e = do
              -- TODO: log properly
              traceM e

              throwError $ error $ webLoginExceptionsClientToString $ webLoginExceptionsServer__to__WebLoginExceptionsClient e

      in mkEffectFn5 \mutation args context resolveInfo helpers -> runExceptWebLoginExceptions do
        -- | traceM { mutation, args, context, resolveInfo, helpers }
        -- | traceM { context }

        (input ::WebLoginInput) <- runExcept (decodeWebLoginInput args.input)
            # either (throwError <<< WebLoginExceptionsServer__Internal__CannotDecodeInput) pure

        -- | traceM { input }

        user <- withConnectionExceptT context.ownerPgPool WebLoginExceptionsServer__Internal__CannotCreateDbConnect \connection -> do
          (result :: Array (Row4 String String (Maybe String) (Maybe String))) <-
            mapErrorExceptT WebLoginExceptionsServer__Internal__LoginFailed
            $ ExceptT
            $ PostgreSQL.query connection
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

          -- | traceM { result }

          user <-
            case result of
                [] -> throwError WebLoginExceptionsServer__LoginFailed
                [Row4 id username name avatar_url] -> pure { id, username, name, avatar_url }
                _ -> throwError WebLoginExceptionsServer__Internal__Login__ExpectedArrayWith1Elem

          -- | traceM { user }

          pure user

        mapErrorExceptT WebLoginExceptionsServer__Internal__SetId
          $ maybeToExceptT
          $ PostgreSQL.execute context.pgClient
          ( PostgreSQL.Query
            """
            select set_config($1, $2, true);
            """
          )
          (PostgreSQL.Row2 "jwt.claims.user_id" user.id)

        -- | traceM "set_config"

        mapErrorExceptT WebLoginExceptionsServer__Internal__PassportLoginError
          $ maybeToExceptT
          $ ApiServer.PassportMethodsFixed.login
            (ApiServer.PassportMethodsFixed.UserUUID user.id)
            Passport.defaultLoginOptions
            context.req

        traceM "passport login"

        output <- liftAff $ Promise.toAffE $
          runEffectFn2
          helpers.selectGraphQLResultFromTable
          (appPublicUsersFragment build.pgSql.fragment)
          (runFn2 mkSelectGraphQLResultFromTable user.id build.pgSql)

        output' <-
          case output of
            [output'] -> pure output'
            _ -> throwError WebLoginExceptionsServer__Internal__Output__ExpectedArrayWith1Elem

        traceM { "web login output": output }

        pure { "data": output' }
    }
  }

module ApiServer.Postgraphile where

import ApiServer.Config
import ApiServer.PassportLoginPlugin
import Data.Function.Uncurried
import Effect.Uncurried
import Node.Express.Types
import PathyExtra
import Postgraphile
import Protolude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Array as Array
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Foreign.Object as Object
import Node.Express.App as Express
import Node.HTTP as Node.HTTP
import Postgraphile as Postgraphile
import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed
import Node.Express.Passport as Passport

postgraphileOptions :: _ -> PostgraphileOptions
postgraphileOptions config =
  { pluginHook: makePluginHook [pgPubsub]
  , ownerConnectionString: "postgres://" <> config.databaseOwnerUser <> ":" <> NonEmptyString.toString config.databaseOwnerPassword <> "@" <> config.databaseHost <> "/" <> config.databaseName
  , subscriptions: true
  , simpleSubscriptions: true
  , enableQueryBatching: true
  , dynamicJson: true
  , ignoreRBAC: false
  , ignoreIndexes: false
  , setofFunctionsContainNulls: false
  , graphiql:
      case config.target of
           Development _ -> true
           _ -> false
  , enhanceGraphiql: true
  , disableQueryLog: true
  , extendedErrors:
      case config.target of
           Development _ ->
             [ "errcode"
             , "severity"
             , "detail"
             , "hint"
             , "positon"
             , "internalPosition"
             , "internalQuery"
             , "where"
             , "schema"
             , "table"
             , "column"
             , "dataType"
             , "constraint"
             , "file"
             , "line"
             , "routine"
             ]
           _ -> ["errcode"]
  , showErrorStack:
      case config.target of
           Development _ -> true
           _ -> false

  , watchPg:
      case config.target of
           Development _ -> true
           _ -> false
  , sortExport: true
  , exportGqlSchemaPath:
      case config.target of
           Production -> Nullable.null
           Development developmentConfigTarget -> Nullable.notNull $ either printPathPosixSandboxAny printPathPosixSandboxAny developmentConfigTarget.exportGqlSchemaPath
  , exportJsonSchemaPath:
      case config.target of
           Production -> Nullable.null
           Development developmentConfigTarget -> Nullable.notNull $ either printPathPosixSandboxAny printPathPosixSandboxAny developmentConfigTarget.exportJsonSchemaPath

  , appendPlugins:
      [ pgSimplifyInflectorPlugin
      , passportLoginPlugin
      ]

  , graphileBuildOptions:
      { pgSkipInstallingWatchFixtures: true
      }

  , pgSettings: mkEffectFn1 \req -> Promise.fromAff $ liftEffect do
     (user :: Maybe String) <- ApiServer.PassportMethodsFixed.passportMethods.getUser req
     pure $ Object.fromFoldable $ Array.catMaybes
      [ Just $ "role" /\ config.databaseVisitorUser
      , user <#> \user -> "jwt.claims.user_id" /\ user
      ]

  , websocketMiddlewares: config.websocketMiddlewares

  , additionalGraphQLContextFromRequest: mkEffectFn1 \req -> Promise.fromAff $ liftEffect $ pure
      { rootPgPool: config.rootPgPool
      , login: mkEffectFn1 \user -> ApiServer.PassportMethodsFixed.passportMethods.logIn user Passport.defaultLoginOptions Nothing req
      }
  }

mkMiddleware
  { authPgPool
  , rootPgPool
  , websocketMiddlewares
  , target

  , databaseName
  , databaseHost
  , databasePort
  , databaseOwnerUser
  , databaseOwnerPassword
  , databaseVisitorUser

  } =
    runFn3
    Postgraphile.postgraphile
    authPgPool
    "app_public"
    ( postgraphileOptions
      { databaseName
      , databaseHost
      , databasePort
      , databaseOwnerUser
      , databaseOwnerPassword
      , databaseVisitorUser
      , target
      , websocketMiddlewares
      , rootPgPool
      }
    )



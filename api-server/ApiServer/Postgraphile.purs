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
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Node.Express.App as Express
import Node.HTTP as Node.HTTP
import Postgraphile as Postgraphile

postgraphileOptions :: _ -> PostgraphileOptions
postgraphileOptions config =
  { pluginHook: makePluginHook [pgPubsub]
  , ownerConnectionString: config.databaseUrl
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

  , pgSettings: mkEffectFn1 \req -> undefined

  , websocketMiddlewares: config.websocketMiddlewares

  , additionalGraphQLContextFromRequest: mkEffectFn1 \req -> undefined
  }

mkMiddleware
  { authPgPool
  , rootPgPool
  , websocketMiddlewares
  , databaseUrl
  , target
  } =
    runFn3
    Postgraphile.postgraphile
    authPgPool
    "app_public"
    ( postgraphileOptions
      { databaseUrl
      , target
      , websocketMiddlewares
      , rootPgPool
      }
    )



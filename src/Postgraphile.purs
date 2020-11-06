module Postgraphile where

import Data.Function.Uncurried
import Effect.Uncurried
import Node.Express.Types
import Protolude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Database.PostgreSQL (Pool)
import Node.HTTP as Node.HTTP

data PostgraphileServerPlugin
data PostgraphileServerPluginHook
data PostgraphileAppendPlugin

foreign import postgraphile :: Fn3 Pool String PostgraphileOptions Middleware
foreign import makePluginHook :: Array PostgraphileServerPlugin -> PostgraphileServerPluginHook
foreign import enhanceHttpServerWithSubscriptions :: EffectFn2 Node.HTTP.Server Middleware Unit
foreign import pgPubsub :: PostgraphileServerPlugin
foreign import pgSimplifyInflectorPlugin :: PostgraphileAppendPlugin

-- TODO
type AppUserClaims =
  { role :: String
  , "jwt.claims.user_id" :: String
  }

-- TODO
data AppUser

type PostgraphileOptions =
  { pluginHook                 :: PostgraphileServerPluginHook
  , ownerConnectionString      :: String
  , subscriptions              :: Boolean
  , simpleSubscriptions        :: Boolean
  , enableQueryBatching        :: Boolean
  , dynamicJson                :: Boolean
  , ignoreRBAC                 :: Boolean
  , ignoreIndexes              :: Boolean
  , setofFunctionsContainNulls :: Boolean
  , graphiql                   :: Boolean
  , enhanceGraphiql            :: Boolean
  , disableQueryLog            :: Boolean
  , extendedErrors             :: Array String
  , showErrorStack             :: Boolean
  , watchPg                    :: Boolean
  , sortExport                 :: Boolean
  , exportGqlSchemaPath        :: Nullable String
  , exportJsonSchemaPath       :: Nullable String
  , appendPlugins              :: Array PostgraphileAppendPlugin
  , graphileBuildOptions ::
    { pgSkipInstallingWatchFixtures :: Boolean
    }

  , pgSettings ::
      EffectFn1
      Request
      (Promise AppUserClaims)

  , websocketMiddlewares :: Array Middleware
  , additionalGraphQLContextFromRequest ::
      EffectFn1
      Request
      ( Promise
        { claims :: AppUserClaims
        , rootPgPool :: Pool
        , login :: EffectFn1 AppUser (Promise AppUser)
        }
      )
  }
module Webpack.Types where

import Data.String.Regex
import Data.String.Regex.Flags
import Data.String.Regex.Unsafe
import Protolude
import Node.Path
import Foreign
import Foreign.Object (Object)
import Foreign.Object as Object

import Data.Nullable (Nullable)

data LoaderOptions

type UseElement = { loader :: String, options :: Nullable LoaderOptions }

type Rule = { test :: Regex, use :: Array UseElement }

data SplitChunksConfig

data WebpackEntrypont

data Compilation

data RawSource

data WebpackPluginInstance

type Configuration =
  { bail :: Boolean
  , context :: FilePath -- Path Abs Dir
  , devServer :: Foreign
  , devtool :: Foreign
  , entry :: Object (Array FilePath) -- Path Abs File
  , mode :: String
  , "module" :: { rules :: Array Rule }
  , node :: Foreign
  , optimization :: { minimize :: Boolean
                    , noEmitOnErrors :: Boolean
                    , nodeEnv :: Boolean
                    , runtimeChunk :: Foreign
                    , splitChunks :: Foreign
                    }
  , output :: { chunkFilename :: Foreign
              , filename :: String
              , libraryTarget :: String
              , path :: FilePath -- Path Abs Dir
              , publicPath :: String
              }
  , plugins :: Array WebpackPluginInstance
  , profile :: Boolean
  , resolve :: { extensions :: Array String
               -- | , modules :: Array String
               }
  , resolveLoader :: { alias :: Object Foreign
                     -- | , mainFields :: Array String
                     -- | , modules :: Array String
                     }
  , stats :: String
  , target :: String
  , watch :: Boolean
  }

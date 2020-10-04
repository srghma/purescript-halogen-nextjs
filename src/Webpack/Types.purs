module Webpack.Types where

import Data.String.Regex
import Data.String.Regex.Flags
import Data.String.Regex.Unsafe
import Protolude

import Data.Nullable (Nullable)

data LoaderOptions

type UseElement = { loader :: String, options :: Nullable LoaderOptions }

type Rule = { test :: Regex, use :: Array UseElement }

data SplitChunksConfig

data WebpackEntrypont

data Compilation

data RawSource

data WebpackPluginInstance


module Webpack.WebpackSpagoLoader where

import Protolude
import Webpack.WebpackConfig.Types

type SpagoOptions =
  { output :: String
  , pursFiles :: Array String
  , compiler :: String
  , compilerOptions :: { censorCodes :: String }
  }

foreign import getAbsoluteOutputDirFromSpago :: String -> Effect String

foreign import getSourcesFromSpago :: String -> Effect (Array String)

foreign import rules :: { spagoAbsoluteOutputDir :: String } -> Array Rule

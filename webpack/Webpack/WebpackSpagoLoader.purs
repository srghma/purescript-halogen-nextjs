module Webpack.WebpackSpagoLoader where

import Protolude
import Webpack.WebpackConfig.Types
import Effect.Uncurried

type SpagoOptions =
  { output :: String
  , pursFiles :: Array String
  , compiler :: String
  , compilerOptions :: { censorCodes :: String }
  }

foreign import getAbsoluteOutputDirFromSpago :: EffectFn1 String String

foreign import getSourcesFromSpago :: EffectFn1 String (Array String)

foreign import rules :: { spagoAbsoluteOutputDir :: String } -> Array Rule

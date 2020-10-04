module NextjsWebpack.WebpackConfig.Rules where

import Data.String.Regex
import Data.String.Regex.Flags
import Data.String.Regex.Unsafe
import Protolude

import Data.Nullable (Nullable)
import Webpack.WebpackConfig.Types
import Webpack.WebpackSpagoLoader as Webpack.WebpackSpagoLoader

foreign import scssAndImagesRules :: { production :: Boolean } -> Array Rule

rules :: { spagoAbsoluteOutputDir :: String, production :: Boolean } -> Array Rule
rules { spagoAbsoluteOutputDir, production } = Webpack.WebpackSpagoLoader.rules { spagoAbsoluteOutputDir } <> scssAndImagesRules { production }

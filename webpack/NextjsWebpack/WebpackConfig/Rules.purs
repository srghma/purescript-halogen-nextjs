module NextjsWebpack.WebpackConfig.Rules where

import Protolude

import Webpack.Types (Rule)
import WebpackSpagoLoader as WebpackSpagoLoader

foreign import scssAndImagesRules :: { production :: Boolean } -> Array Rule

rules :: { spagoAbsoluteOutputDir :: String, production :: Boolean } -> Array Rule
rules { spagoAbsoluteOutputDir, production } = WebpackSpagoLoader.rules { spagoAbsoluteOutputDir } <> scssAndImagesRules { production }

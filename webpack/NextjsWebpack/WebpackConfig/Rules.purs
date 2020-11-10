module NextjsWebpack.WebpackConfig.Rules where

import NextjsWebpack.WebpackConfig.Types
import Protolude

import Data.Nullable as Nullable
import Data.String.Regex.Flags as Regex
import Data.String.Regex.Unsafe as Regex
import Webpack.Types (Rule)
import WebpackSpagoLoader as WebpackSpagoLoader
import Foreign.NullOrUndefined as Foreign.NullOrUndefined

foreign import scssAndImagesRules :: { production :: Boolean } -> Array Rule

rules :: { target :: Target, spagoAbsoluteOutputDir :: String, production :: Boolean } -> Array Rule
rules { target, spagoAbsoluteOutputDir, production } =
  WebpackSpagoLoader.rules { spagoAbsoluteOutputDir }
  <> scssAndImagesRules { production }
  <> case target of
          Target__Server ->
            [ { test: Regex.unsafeRegex "ace-builds" Regex.noFlags
              , use: [ { loader: "null-loader", options: Foreign.NullOrUndefined.undefined } ]
              }
            ]
          _ -> []

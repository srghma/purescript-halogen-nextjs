module Webpack.WebpackConfig.SplitChunksConfig where

import Protolude
import Webpack.WebpackConfig.Types

foreign import splitChunksConfig :: { totalPages :: Int } -> SplitChunksConfig

module NextjsWebpack.WebpackConfig.SplitChunksConfig where

import Protolude
import Webpack.WebpackConfig.Types

import Data.String.Regex.Unsafe as Regex
import Data.String.Regex.Flags as Regex

-- from https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L346
-- this is default config from webpack site
splitChunksConfig :: { totalPages :: Int } -> _
splitChunksConfig { totalPages } =
  { chunks: "all"

  , cacheGroups:
    -- only output is added
    { defaultVendors:
      { test: Regex.unsafeRegex """[\\/](node_modules|output)[\\/]""" Regex.noFlags
      , priority: -10
      }

      -- TODO: empty chunks https://github.com/webpack/webpack/issues/7300
    , "default":
      { minChunks: 2
      , priority: -20
      , reuseExistingChunk: true
      }

    , styles:
      { name: "styles"
      , test: Regex.unsafeRegex """\.s?css$""" Regex.noFlags
      , chunks: "all"
      , minChunks: 2
      , enforce: true
      , reuseExistingChunk: true
      }

    , commons:
        { name: "commons"
        , minChunks: totalPages
        , priority: 20
        }
    }
  }

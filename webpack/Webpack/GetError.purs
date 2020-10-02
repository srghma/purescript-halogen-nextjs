module Webpack.GetError where

import Control.Promise
import Data.Function.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy
import Data.Nullable
import Data.Nullable as Nullable
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray

data WebpackError

type WebpackStats =
  { stats :: Array
    { compilation ::
      { errors :: Array WebpackError
      }
    }
  }

webpackGetErrors :: Fn2 (Nullable WebpackError) WebpackStats (Maybe $ NonEmptyArray WebpackError)
webpackGetErrors = mkFn2 \error stats ->
  case Nullable.toMaybe error of
       Just e -> Just $ NonEmptyArray.singleton e
       Nothing -> Array.findMap (\stat -> NonEmptyArray.fromArray stat.compilation.errors) stats.stats

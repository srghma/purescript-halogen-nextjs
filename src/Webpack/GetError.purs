module Webpack.GetError where

import Control.Promise
import Effect.Uncurried
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
import Unsafe.Coerce
import Webpack.Compiler

webpackGetErrors :: Nullable Error -> MultiStats -> Maybe (NonEmptyArray Error)
webpackGetErrors = \error stats ->
  case Nullable.toMaybe error of
       Just e -> Just $ NonEmptyArray.singleton e
       Nothing -> Array.findMap (\stat -> NonEmptyArray.fromArray stat.compilation.errors) stats.stats

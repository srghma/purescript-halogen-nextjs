module Webpack.Compiler where

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
import Webpack.Types

-- https://github.com/DefinitelyTyped/DefinitelyTyped/blob/7bcd046f24df925802e1d1d04a7fd6f19b54cde0/types/webpack/index.d.ts#L1312
type Compilation =
  { errors :: Array Error
  }

type Stats =
  { compilation :: Compilation
  }

type MultiStats =
  { stats :: Array Stats
  }

type Handler' = EffectFn2 (Nullable Error) Stats Unit
type Handler = Nullable Error -> Stats -> Effect Unit

type MultiHandler' = EffectFn2 (Nullable Error) MultiStats Unit
type MultiHandler = Nullable Error -> MultiStats -> Effect Unit

----------

data Compiler

data MultiCompiler

----------

-- https://github.com/DefinitelyTyped/DefinitelyTyped/blob/7bcd046f24df925802e1d1d04a7fd6f19b54cde0/types/webpack/index.d.ts#L1335
foreign import _webpackCompilerRun :: EffectFn2 Foreign Foreign Unit

webpackCompilerRun
  :: Compiler
  -> Handler
  -> Effect Unit
webpackCompilerRun = \compiler handler -> runEffectFn2 _webpackCompilerRun (coerceCompiler compiler) (coerceHandler' $ coerceHandler handler)
  where
    coerceCompiler = (unsafeCoerce :: Compiler -> Foreign)
    coerceHandler' = (unsafeCoerce :: Handler' -> Foreign)
    coerceHandler = (mkEffectFn2 :: Handler -> Handler')

webpackCompilerRunMulti
  :: MultiCompiler
  -> MultiHandler
  -> Effect Unit
webpackCompilerRunMulti = \compiler multihandler -> runEffectFn2 _webpackCompilerRun (coerceCompiler compiler) (coerceMultiHandler' $ coerceMultiHandler multihandler)
  where
    coerceCompiler = (unsafeCoerce :: MultiCompiler -> Foreign)
    coerceMultiHandler' = (unsafeCoerce :: MultiHandler' -> Foreign)
    coerceMultiHandler = (mkEffectFn2 :: MultiHandler -> MultiHandler')

----------

foreign import _webpack :: EffectFn1 Foreign Foreign

webpackCompiler :: Configuration -> Effect Compiler
webpackCompiler = \compiler -> runEffectFn1 _webpack (coerceConfig compiler) # map coerceToCompiler
  where
    coerceToCompiler = (unsafeCoerce :: Foreign -> Compiler)
    coerceConfig = (unsafeCoerce :: Configuration -> Foreign)

webpackCompilerMulti :: Array Configuration -> Effect MultiCompiler
webpackCompilerMulti = \compiler -> runEffectFn1 _webpack (coerceConfig compiler) # map coerceToCompiler
  where
    coerceToCompiler = (unsafeCoerce :: Foreign -> MultiCompiler)
    coerceConfig = (unsafeCoerce :: Array Configuration -> Foreign)

module Mjml where

import Protolude
import Effect.Uncurried

data ValidationLevel
  = ValidationLevel__Strict
  | ValidationLevel__Soft
  | ValidationLevel__Skip

printValidationLevel =
  case _ of
       ValidationLevel__Strict -> "strict"
       ValidationLevel__Soft   -> "soft"
       ValidationLevel__Skip   -> "skip"

type MjmlOptionsInternal =
  { keepComments ::         Boolean
  , ignoreIncludes ::       Boolean
  , beautify ::             Boolean
  , minify ::               Boolean
  , validationLevel ::      String
  }

type MjmlOptions =
  -- | { fonts ::                Object
  { keepComments ::         Boolean
  , ignoreIncludes ::       Boolean
  , beautify ::             Boolean
  , minify ::               Boolean
  , validationLevel ::      ValidationLevel
  -- | , filePath ::             String
  -- | , preprocessors ::        Array
  -- | , juicePreserveTags ::    Boolean
  -- | , minifyOptions ::        Options
  -- | , mjmlConfigPath ::       String
  -- | , useMjmlConfigOptions :: Boolean
  }

defaultMjmlOptions :: MjmlOptions
defaultMjmlOptions =
  { keepComments:    true
  , ignoreIncludes:  false
  , beautify:        false
  , minify:          false
  , validationLevel: ValidationLevel__Soft
  }

mjmlOptionsToInternal :: MjmlOptions -> MjmlOptionsInternal
mjmlOptionsToInternal
  { keepComments
  , ignoreIncludes
  , beautify
  , minify
  , validationLevel
  } =
    { keepComments
    , ignoreIncludes
    , beautify
    , minify
    , validationLevel: printValidationLevel validationLevel
    }

foreign import _mjml2html :: EffectFn2 String MjmlOptionsInternal String

mjml2html :: String -> MjmlOptions -> Effect String
mjml2html input mjmlOptions = runEffectFn2 _mjml2html input (mjmlOptionsToInternal mjmlOptions)

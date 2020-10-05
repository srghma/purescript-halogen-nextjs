module NextjsWebpack.WebpackConfig.SpagoOptions where

import Protolude

import Data.String as String
import WebpackSpagoLoader
import Effect.Uncurried
import Pathy
import PathyExtra

spagoOptions :: Path Abs File -> Effect SpagoOptions
spagoOptions spagoDhall = do
  let spagoDhall' = printPathPosixSandboxAny spagoDhall
  output <- runEffectFn1 getAbsoluteOutputDirFromSpago spagoDhall'
  pursFiles <- runEffectFn1 getSourcesFromSpago spagoDhall'
  pure
    { output
    , pursFiles
    , compiler: "psa"
    -- note that warnings are shown only when file is recompiled, delete output folder to show all warnings

    , compilerOptions:
      { censorCodes: String.joinWith ","
        [ "ImplicitQualifiedImport"
        , "UnusedImport"
        , "ImplicitImport"
        ]
      -- strict: true
      }
    }
module Webpack.WebpackConfig.SpagoOptions where

import Protolude

import Data.String as String
import Webpack.WebpackSpagoLoader

-- TODO: from config
spagoDhall = "./spago.dhall"

spagoOptions = do
  output <- getAbsoluteOutputDirFromSpago spagoDhall
  pursFiles <- getSourcesFromSpago spagoDhall
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

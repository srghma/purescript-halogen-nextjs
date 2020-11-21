module FeatureTests.Config where

import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Env as Env
import Foreign.Object (Object)

type Config =
  { databaseName          :: String
  , databaseHost          :: String
  , databasePort          :: Maybe Int
  , databaseOwnerUser     :: String
  , databaseOwnerPassword :: String
  , clientRootUrl         :: String
  , chromedriverUrl       :: String
  , chromeBinaryPath      :: String
  , remoteDownloadDirPath :: String
  , chromeUserDataDirPath :: String
  }

config :: Effect Config
config = Env.parse Env.defaultInfo $ ado
  databaseName          <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "databaseName" Env.defaultVar
  databaseHost          <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "databaseHost" Env.defaultVar
  databasePort          <- Env.var (Env.int <#> Just) "databasePort" (Env.defaultVar { def = Just Nothing })
  databaseOwnerUser     <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "databaseOwnerUser" Env.defaultVar
  databaseOwnerPassword <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "databaseOwnerPassword" (Env.defaultVar { sensitive = true })
  clientRootUrl         <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "clientRootUrl" Env.defaultVar
  chromedriverUrl       <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "chromedriverUrl" Env.defaultVar
  chromeBinaryPath      <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "chromeBinaryPath" Env.defaultVar
  remoteDownloadDirPath <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "remoteDownloadDirPath" Env.defaultVar
  chromeUserDataDirPath <- Env.var (Env.nonEmptyString <#> NonEmptyString.toString) "chromeUserDataDirPath" Env.defaultVar

  in
    { databaseName
    , databaseHost
    , databasePort
    , databaseOwnerUser
    , databaseOwnerPassword
    , clientRootUrl
    , chromedriverUrl
    , chromeBinaryPath
    , remoteDownloadDirPath
    , chromeUserDataDirPath
    }

module NextjsWebpack.Utils.OneServerATimeSpawner where

import Control.Promise
import Effect.Uncurried
import NodeChildProcessExtra
import Pathy
import PathyExtra
import Protolude

import Chokidar as Chokidar
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.NonEmpty (NonEmpty(..))
import Data.Posix.Signal as Data.Posix.Signal
import Data.Time.Duration (Milliseconds(..))
import Effect.Class.Console (log)
import Effect.Ref as Ref
import FRP.Event (Event)
import FRP.Event as Event
import FRP.Event.Time as Event
import FRPEventExtra as FRPEventExtra
import Foreign (Foreign)
import Foreign as Foreign
import Node.ChildProcess (StdIOBehaviour(..), ChildProcess)
import Node.ChildProcess as Node.ChildProcess
import Node.Process as Node.Process
import Node.Stream (Stream, Write)
import Unsafe.Coerce (unsafeCoerce)

oneServerATimeSpawner :: Effect
  { spawnServer ::
    { serverFilePath :: String
    , port :: Int
    , compiliedClientDirPath :: String
    }
    -> Effect Unit
  , cleanupServer :: Effect Unit
  }
oneServerATimeSpawner = do
  { spawn, killIfRunning } <- withOneProcessATime

  pure
    { spawnServer: \config -> do
        (serverFilePath :: Path Abs File) <- parseAbsFile posixParser config.serverFilePath # maybe (throwError $ error "invalid serverFilePath") pure
        (compiliedClientDirPath :: Path Abs Dir) <- parseAbsDir posixParser config.compiliedClientDirPath # maybe (throwError $ error "invalid compiliedClientDirPath") pure

        spawn $
          Node.ChildProcess.spawn
          "node"
          [ "--trace-deprecation"
          , printPathPosixSandboxAny serverFilePath
          , "--port"
          , show config.port
          , "--root-path"
          , printPathPosixSandboxAny compiliedClientDirPath
          ]
          (Node.ChildProcess.defaultSpawnOptions { stdio = noInputOnlyOutput })

        log $ "[Server] running at port " <> show config.port <> ", path = " <> printPathPosixSandboxAny serverFilePath <> ", client dir = " <> printPathPosixSandboxAny compiliedClientDirPath
    , cleanupServer: killIfRunning
    }

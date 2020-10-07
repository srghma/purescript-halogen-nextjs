module NextjsWebpack.Utils.OnFilesChangedRunCommand where

import Control.Promise
import Effect.Uncurried
import Pathy
import Protolude

import Chokidar as Chokidar
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.NonEmpty (NonEmpty(..))
import Data.Posix.Signal as Data.Posix.Signal
import Data.Time.Duration (Milliseconds(..))
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
import NodeChildProcessExtra

onFilesChangedRunCommand :: { files :: Array String, command :: Array String } -> Effect Unit
onFilesChangedRunCommand config = do
  files <- NonEmptyArray.fromArray config.files # maybe (throwError $ error "expected non empty files") pure
  command <- NonEmptyArray.fromArray config.command # maybe (throwError $ error "expected non empty command") pure

  let (event :: Event String) = Event.debounce (Milliseconds 100.0) (Chokidar.watch files)

  let command' = NonEmptyArray.uncons command

  spawn <- withOneProcessATime

  let onEvent :: String -> Effect Unit
      onEvent path = do
         traceM { m: "onEvent", path }

         spawn (Node.ChildProcess.spawn command'.head command'.tail (Node.ChildProcess.defaultSpawnOptions { stdio = noInputOnlyOutput }))

  void $ Event.subscribe event onEvent

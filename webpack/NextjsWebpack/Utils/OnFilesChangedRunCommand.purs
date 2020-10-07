module NextjsWebpack.Utils.OnFilesChangedRunCommand where

import Control.Promise
import Effect.Uncurried
import Pathy
import Protolude

import Chokidar as Chokidar
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.NonEmpty (NonEmpty(..))
import Data.Time.Duration (Milliseconds(..))
import FRP.Event (Event)
import FRP.Event as Event
import FRP.Event.Time as Event
import FRPEventExtra as FRPEventExtra
import Foreign (Foreign)
import Foreign as Foreign
import Node.ChildProcess (StdIOBehaviour(..), ChildProcess)
import Node.ChildProcess as Node.ChildProcess
import Effect.Ref as Ref
import Data.Posix.Signal as Data.Posix.Signal

noInputOnlyOutput = [Just Ignore, Nothing, Nothing]

withOneProcessATime :: Effect (Effect ChildProcess -> Effect Unit)
withOneProcessATime = do
  latest <- Ref.new Nothing

  let spawn runProcess = do
        Ref.read latest >>= maybe (pure unit) (Node.ChildProcess.kill Data.Posix.Signal.SIGKILL)

        childProcess <- runProcess

        Ref.write (Just childProcess) latest

        pure unit

  pure spawn

onFilesChangedRunCommand :: { files :: Array String, command :: Array String } -> Effect Unit
onFilesChangedRunCommand config = do
  files <- NonEmptyArray.fromArray config.files # maybe (throwError $ error "expected non empty files") pure
  command <- NonEmptyArray.fromArray config.command # maybe (throwError $ error "expected non empty command") pure

  let (event :: Event String) = Event.debounce (Milliseconds 100.0) (FRPEventExtra.distinct (Chokidar.watch files))

  let command' = NonEmptyArray.uncons command

  spawn <- withOneProcessATime

  let onEvent :: String -> Effect Unit
      onEvent _ = spawn (Node.ChildProcess.spawn command'.head command'.tail (Node.ChildProcess.defaultSpawnOptions { stdio = noInputOnlyOutput }))

  void $ Event.subscribe event onEvent

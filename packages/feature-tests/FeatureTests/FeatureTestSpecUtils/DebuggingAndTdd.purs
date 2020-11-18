module FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd where

import Protolude
import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Data.Maybe
import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import Test.Spec
import Unsafe.Coerce
import FeatureTests.FeatureTestSpec
import Run (Run)
import Run as Run
import Run.Reader as Run
import Lunapark as Lunapark
import Node.Process as Node.Process
import Node.Encoding as Node.Encoding
import Node.Stream as Node.Stream
import Effect.Ref as Ref
import Control.Monad.Rec.Class
import Node.ReadLine as Node.ReadLine

-- | readlineQuestion :: String -> Node.ReadLine.Interface -> Aff String
-- | readlineQuestion questionString interface = makeAff \callback -> do
-- |   Node.ReadLine.question questionString (callback <<< Right) interface
-- |   pure nonCanceler

-- | pressEnterToContinue :: Run FeatureTestRunEffects Unit
-- | pressEnterToContinue =
-- |   Run.ask >>=
-- |   \config -> Run.liftAff $ void $ readlineQuestion "Press \"Enter\" (but not \"CTRL-D\") to continue: " config.readLineInterface

module FeatureTests.Tests.Login.SuccessSpec where

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
import Lunapark as Lunapark
import Node.Process as Node.Process
import Node.Encoding as Node.Encoding
import Node.Stream as Node.Stream
import Effect.Ref as Ref
import Control.Monad.Rec.Class
import Node.ReadLine as Node.ReadLine

spec :: Run FeatureTestRunEffects Unit
spec = do
  Lunapark.go "http://my-site.com"

  -- | Run.liftAff pressCtrlDToContinue

  Run.liftAff $ liftEffect do
     interface <- Node.ReadLine.createConsoleInterface Node.ReadLine.noCompletion
     Node.ReadLine.setPrompt "> " 2 interface
     Node.ReadLine.prompt interface
     Node.ReadLine.setLineHandler interface $ \s ->
       if s == "quit"
          then Node.ReadLine.close interface
          else do
           log $ "You typed: " <> s
           Node.ReadLine.prompt interface

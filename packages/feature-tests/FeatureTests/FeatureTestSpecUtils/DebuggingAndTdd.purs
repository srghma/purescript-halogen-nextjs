module FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd where

import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Control.Monad.Rec.Class
import Data.Identity
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import Protolude
import Test.Spec
import Unsafe.Coerce

import Data.Functor.Variant (FProxy(..))
import Effect.Ref as Ref
import Lunapark as Lunapark
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine (Interface)
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Run (Run)
import Run as Run
import Run.Reader as Run

readlineQuestion :: String -> Node.ReadLine.Interface -> Aff String
readlineQuestion questionString interface = makeAff \callback -> do
  Node.ReadLine.question questionString (callback <<< Right) interface
  pure nonCanceler

pressEnterToContinue' :: Node.ReadLine.Interface -> Aff Unit
pressEnterToContinue' readLineInterface = void $ readlineQuestion "Press \"Enter\" (but not \"CTRL-D\") to continue: " readLineInterface

------------------------

data PressEnterToContinueF a
  = PressEnterToContinue a

derive instance functorPressEnterToContinueF :: Functor PressEnterToContinueF

type PRESS_ENTER_TO_CONTINUE = FProxy PressEnterToContinueF

_pressEnterToContinue = SProxy :: SProxy "pressEnterToContinue"

pressEnterToContinue :: forall r. Run (pressEnterToContinue :: PRESS_ENTER_TO_CONTINUE | r) Unit
pressEnterToContinue = Run.lift _pressEnterToContinue (PressEnterToContinue unit)

type PressEnterToContinueEffect r = ( pressEnterToContinue :: PRESS_ENTER_TO_CONTINUE | r )

handlePressEnterToContinue
  :: forall r
   . Node.ReadLine.Interface
  -> PressEnterToContinueF
  ~> Run
     ( aff :: Run.AFF
     | r
     )
handlePressEnterToContinue interface = case _ of
  PressEnterToContinue next -> do
    Run.liftAff $ pressEnterToContinue' interface
    pure next

runPressEnterToContinue
  :: forall r
   . Node.ReadLine.Interface
  -> Run
     ( aff :: Run.AFF
     | PressEnterToContinueEffect
     + r
     )
  ~> Run
     ( aff :: Run.AFF
     | r
     )
runPressEnterToContinue interface = Run.interpret (Run.on _pressEnterToContinue (handlePressEnterToContinue interface) Run.send)

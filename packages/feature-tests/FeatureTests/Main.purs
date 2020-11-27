module FeatureTests.Main where

import Protolude
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run
import Data.Symbol (SProxy(..))

data MyActionF a
  = MyAction__Do a

derive instance functorMyActionF ∷ Functor MyActionF

_my_action = SProxy ∷ SProxy "my_action"

type MY_ACTION = Run.FProxy MyActionF

type MyActionEffect r = ( my_action ∷ MY_ACTION | r )

liftMyAction ∷ ∀ r. MyActionF Unit → Run (MyActionEffect r) Unit
liftMyAction = Run.lift _my_action

myAction__Do ∷ ∀ r. Run (MyActionEffect r) Unit
myAction__Do = liftMyAction $ MyAction__Do unit

data MyError
  = MyError
  -- | | MyOtherError

handleMyAction :: forall r. MyActionF ~> Run (except ∷ Run.EXCEPT MyError | r)
handleMyAction = case _ of
  MyAction__Do next -> do
    -- | liftEffect $ Console.log str
    _ <- Run.throw MyError
    pure next

runMyAction
  :: forall r
   . Run (except ∷ Run.EXCEPT MyError, my_action :: MY_ACTION | r)
  ~> Run (except ∷ Run.EXCEPT MyError | r)
runMyAction = Run.interpret (Run.on _my_action handleMyAction Run.send)

main :: Effect Unit
main = do
  let
    body :: forall r . Run (except ∷ Run.EXCEPT MyError, my_action :: MY_ACTION | r) Unit
    body = do
      insideBodyRes <-
        Run.catch
        (\catchedError -> traceM { catchedError }
        )
        (Run.throw MyError)
      traceM { insideBodyRes }

    interpretX :: Run (except ∷ Run.EXCEPT MyError, my_action :: MY_ACTION) Unit -> Either MyError Unit
    interpretX x =
      -- | Run.runBaseAff'
      Run.extract
      $ Run.runExcept
      $ runMyAction
      x

  let bodyRes = interpretX body

  traceM { bodyRes }

  pure unit

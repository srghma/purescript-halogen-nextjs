module NextjsApp.Navigate where

import Protolude
import NextjsApp.Route as NextjsApp.Route
import Control.Monad.Reader (asks)

navigate
  :: forall r m
   . MonadEffect m
  => MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m
  => NextjsApp.Route.Route
  -> m Unit
navigate route = do
  navigate' <- asks _.navigate
  liftEffect $ navigate' route

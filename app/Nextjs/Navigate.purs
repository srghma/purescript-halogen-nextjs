module Nextjs.Navigate where

import Protolude
import Nextjs.Route as Nextjs.Route
import Control.Monad.Reader (asks)

navigate
  :: forall r m
   . MonadEffect m
  => MonadAsk { navigate :: Nextjs.Route.Route -> Effect Unit | r } m
  => Nextjs.Route.Route
  -> m Unit
navigate route = do
  navigate' <- asks _.navigate
  liftEffect $ navigate' route

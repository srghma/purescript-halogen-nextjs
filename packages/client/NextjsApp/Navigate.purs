module NextjsApp.Navigate where

import Protolude

import Control.Monad.Reader (asks)

import NextjsApp.Route as NextjsApp.Route

navigate ::
  forall r m.
  MonadEffect m =>
  MonadAsk { navigate :: Variant NextjsApp.Route.WebRoutesWithParamRow -> Effect Unit | r } m =>
  Variant NextjsApp.Route.WebRoutesWithParamRow ->
  m Unit
navigate route = do
  navigate' <- asks _.navigate
  liftEffect $ navigate' route

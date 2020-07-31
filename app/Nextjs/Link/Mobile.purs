module Nextjs.Link.Mobile where

import Protolude (pure, unit)

import Nextjs.AppM (EnvLinkHandleActions)

mkLinkHandleActions
  :: EnvLinkHandleActions
mkLinkHandleActions =
  { handleInitialize: pure unit
  , handleFinalize: pure unit
  , handleLinkIsInViewport: \_ -> pure unit
  }

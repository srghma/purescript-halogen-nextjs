module NextjsApp.Link.Mobile where

import Effect.Exception.Unsafe (unsafeThrow)
import NextjsApp.AppM (EnvLinkHandleActions)
import Protolude (pure, unit)

mkLinkHandleActions
  :: EnvLinkHandleActions
mkLinkHandleActions =
  { handleInitialize: pure unit
  , handleLinkIsInViewport: \_ -> unsafeThrow "handleLinkIsInViewport should not be ever called"
  }

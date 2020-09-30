module Nextjs.Link.Mobile where

import Effect.Exception.Unsafe (unsafeThrow)
import Nextjs.AppM (EnvLinkHandleActions)
import Protolude (pure, unit)

mkLinkHandleActions
  :: EnvLinkHandleActions
mkLinkHandleActions =
  { handleInitialize: pure unit
  , handleLinkIsInViewport: \_ -> unsafeThrow "handleLinkIsInViewport should not be ever called"
  }

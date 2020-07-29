module Nextjs.PageImplementations.Index (component) where

import Protolude
import Control.Monad.Reader (class MonadAsk)
import Data.Const (Const(..))
import Effect.Class (class MonadEffect)
import FRP.Event (Event)
import Halogen (ComponentSlot, Slot)
import Halogen as H
import Halogen.HTML as HH
import Nextjs.AppM (AppM)
import Nextjs.Link.Default as Nextjs.Link.Default
import Nextjs.Navigate (navigate)
import Nextjs.Route
import Web.HTML (HTMLDocument, HTMLHeadElement)
import Web.IntersectionObserver (IntersectionObserver)
import Web.IntersectionObserverEntry (IntersectionObserverEntry)

allRoutes :: Array Route
allRoutes =
  [ Ace
  , Basic
  , Components
  , ComponentsInputs
  , ComponentsMultitype
  , EffectsAffAjax
  , EffectsEffectRandom
  , HigherOrderComponents
  , Interpret
  , KeyboardInput
  , Lifecycle
  , DynamicInput
  , DeeplyNested
  , TextNodes
  , Lazy
  , Buttons ButtonsRoute__Buttons
  , Buttons ButtonsRoute__Fabs
  , Buttons ButtonsRoute__IconButtons
  ]

component :: forall q i o . H.Component q i o AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render
  :: forall action state
   . state
  -> HH.ComponentHTML action ( mylink :: Slot (Const Void) Void Route ) AppM
render _ =
  HH.ul_ $
    allRoutes <#> (\route ->
      HH.li_ $
        [ HH.slot
          (SProxy :: SProxy "mylink")
          route
          Nextjs.Link.Default.component
          { route, text: show route }
          absurd
        ]
      )

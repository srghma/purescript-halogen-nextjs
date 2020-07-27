module Lib.Pages.Index.Default (component) where

import Protolude
import Control.Monad.Reader (class MonadAsk)
import Data.Const (Const(..))
import Effect.Class (class MonadEffect)
import FRP.Event (Event)
import Halogen (ComponentSlot, Slot)
import Halogen as H
import Halogen.HTML as HH
import Nextjs.AppM (AppM)
import Nextjs.Link as Nextjs.Link
import Nextjs.Navigate (navigate)
import Nextjs.Route (Route(..))
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
  ]

component :: forall q i o . H.Component q i o AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render state = HH.div_ [HH.text "asdf"]

-- | render
-- |   :: forall t1 t15 m t26 t4
-- |    . MonadEffect m
-- |   => MonadAsk
-- |       { clientPagesManifest :: (Nextjs.Route.PagesRec { css :: Array String , js :: Array String })
-- |       , document :: HTMLDocument
-- |       , head :: HTMLHeadElement
-- |       , intersectionObserver :: IntersectionObserver
-- |       , intersectionObserverEvent :: Event (Array IntersectionObserverEntry)
-- |       | t26
-- |       }
-- |       m
-- |   -> HH.HTML
-- |       (ComponentSlot
-- |           ( mylink :: Slot (Const Void) Void Route
-- |           | t15
-- |           )
-- |           AppM
-- |           t4
-- |       )
-- |       t4
-- | render state =
-- |   HH.ul_ $
-- |     allRoutes <#> (\route ->
-- |       HH.li_ $
-- |         let route' = show route
-- |         in
-- |           [ HH.slot (SProxy :: SProxy "mylink") route Lib.Link.component { route, text: route' } absurd
-- |           ]
-- |       )

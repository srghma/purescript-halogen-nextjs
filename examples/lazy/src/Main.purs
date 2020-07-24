module Example.Lazy.Main (component) where

import Protolude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Elements.Keyed as HK
import Halogen.HTML.Properties as HP
import Data.Const
import Data.Symbol (SProxy(..))
import Example.Lazy.LazyLoaded as Example.Lazy.LazyLoaded

type ChildSlots =
  ( lazyChild :: H.Slot (Const Void) Void Unit
  )

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
    }

-- | Example to show
-- |
-- | const ProfilePage = React.lazy(() => import('./ProfilePage')); // Lazy-loaded
-- |
-- | // Show a spinner while the profile is loading
-- | <Suspense fallback={<Spinner />}>
-- |   <ProfilePage />
-- | </Suspense>

render :: forall m query. Unit -> H.ComponentHTML query ChildSlots m
render _ =
  HH.div_
    [ HH.text "I'm parent"
    , HH.slot (SProxy :: _ "lazyChild") unit Example.Lazy.LazyLoaded.component unit absurd
    ]

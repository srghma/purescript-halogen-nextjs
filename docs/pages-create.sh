pages-create () {
  mkdir -p ~/projects/purescript-halogen-nextjs/client/Nextjs/Pages/$1
  cat > ~/projects/purescript-halogen-nextjs/client/Nextjs/Pages/$1/$2.purs <<- EOM
module Nextjs.Pages.$1.$2 (page) where

import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Protolude (Unit, liftAff, unit, ($))
import Halogen as H
import Nextjs.PageImplementations.$1.$2 as Implementation

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Implementation.component
  , title: "Halogen MWC - $1 $2"
  }

page :: Page
page = mkPage pageSpec
EOM

  mkdir -p ~/projects/purescript-halogen-nextjs/client/Nextjs/Pages/$1
  cat > ~/projects/purescript-halogen-nextjs/client/Nextjs/Pages/$1/$2.css <<- EOM
import '@rmwc/button/styles';
EOM

mkdir -p ~/projects/purescript-halogen-nextjs/client/Nextjs/Pages/$1
cat > ~/projects/purescript-halogen-nextjs/client/Nextjs/Pages/$1/$2.deps.js <<- EOM
import './$1.css'
EOM

  mkdir -p ~/projects/purescript-halogen-nextjs/client/Nextjs/PageImplementations/$1
  cat > ~/projects/purescript-halogen-nextjs/client/Nextjs/PageImplementations/$1/$2.purs <<- EOM
module Nextjs.PageImplementations.$1.$2 (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = Unit

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render :: forall m. State -> H.ComponentHTML Void () m
render state = HH.div_ [ HH.text "Button" ]
EOM
}

pages-create Buttons Buttons
pages-create Buttons Fabs
pages-create Buttons IconButtons

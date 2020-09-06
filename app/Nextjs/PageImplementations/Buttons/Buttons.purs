module Nextjs.PageImplementations.Buttons.Buttons (component) where

import Protolude

import Data.Percent as Percent
import Halogen (AttrName(..))
import Halogen as H
import Halogen.HTML (attr) as HP
import Halogen.HTML as HH
import Protolude.Url as Url
import Halogen.SVG.Elements as Halogen.SVG.Elements
import Halogen.SVG.Attributes as Halogen.SVG.Attributes

type Query = Const Void

type Input = Unit

type Output = Void

type State = Unit

type Action = Void

type ChildSlots = ()

component :: forall m. H.Component Query Input Output m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
    }

render :: forall m. State -> H.ComponentHTML Action ChildSlots m
render state = HH.div_
  [ HH.text "Button"
  ]

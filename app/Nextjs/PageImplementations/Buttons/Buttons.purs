module Nextjs.PageImplementations.Buttons.Buttons (component) where

import Protolude

import Data.Percent as Percent
import Halogen (AttrName(..))
import Halogen as H
import Halogen.HTML (attr) as HP
import Halogen.HTML as HH
import Protolude.Url as Url
import RMWC.Blocks.Avatar as RMWC.Blocks.Avatar
import MWCComponents.Blocks.Button as MWCComponents.Blocks.Button
import MWCComponents.Blocks.CircularProgress as MWCComponents.Blocks.CircularProgress
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

  , MWCComponents.Blocks.Button.button (MWCComponents.Blocks.Button.defaultConfig { label = "Button" }) []
  , MWCComponents.Blocks.Button.button (MWCComponents.Blocks.Button.defaultConfig { label = "Icon", icon = "favorite" }) []
  , MWCComponents.Blocks.Button.button (MWCComponents.Blocks.Button.defaultConfig { label = "Trailing", icon = "keyboard_arrow_right", trailingIcon = true }) []
  , MWCComponents.Blocks.Button.button
    MWCComponents.Blocks.Button.defaultConfig
    [ MWCComponents.Blocks.CircularProgress.circularProgress MWCComponents.Blocks.CircularProgress.defaultConfig []
    ]
  , MWCComponents.Blocks.Button.button
    (MWCComponents.Blocks.Button.defaultConfig { label = "Trailing" })
    [ MWCComponents.Blocks.CircularProgress.circularProgress MWCComponents.Blocks.CircularProgress.defaultConfig []
    ]

  -- | , RMWC.Blocks.Button.button (RMWC.Blocks.Button.defaultConfig { label = "Raised", raised = true })
  -- | , RMWC.Blocks.Button.button (RMWC.Blocks.Button.defaultConfig { label = "Unelevated", unelevated = true })
  -- | , RMWC.Blocks.Button.button (RMWC.Blocks.Button.defaultConfig { label = "Outlined", outlined = true })

  -- | , RMWC.Blocks.Button.button (RMWC.Blocks.Button.defaultConfig { label = "Danger", danger = true, raised = true })
  -- | , RMWC.Blocks.Button.button (RMWC.Blocks.Button.defaultConfig { label = "Danger", danger = true, outlined = true })
  -- | , RMWC.Blocks.Button.button (RMWC.Blocks.Button.defaultConfig { label = "Danger", danger = true })

  -- | , RMWC.Blocks.Fab.fab (RMWC.Blocks.Fab.defaultConfig { icon = RMWC.Blocks.Fab.Icon_Text "favorite" })
  -- | , RMWC.Blocks.Fab.fab (RMWC.Blocks.Fab.defaultConfig { icon = RMWC.Blocks.Fab.Icon_Text "favorite", mini = true })

  -- | , RMWC.Blocks.Fab.fab (RMWC.Blocks.Fab.defaultConfig { extended = RMWC.Blocks.Fab.Extended_Yes "Create", icon = RMWC.Blocks.Fab.Icon_Text "add" })
  -- | , RMWC.Blocks.Fab.fab (RMWC.Blocks.Fab.defaultConfig { extended = RMWC.Blocks.Fab.Extended_Yes "Create", trailingIcon = RMWC.Blocks.Fab.Icon_Text "add" })
  -- | , RMWC.Blocks.Fab.fab (RMWC.Blocks.Fab.defaultConfig { extended = RMWC.Blocks.Fab.Extended_Yes "Create" })

  -- | , RMWC.Blocks.CircularProgress.circularProgressDeterminate { size: RMWC.Blocks.CircularProgress.Xsmall, progress: Percent.unsafePercent 0.5 }

  -- | , RMWC.Blocks.LinearProgress.linearProgress { progress: Percent.unsafePercent 0.6, buffer: Percent.unsafePercent 0.8 }
  -- | , RMWC.Blocks.LinearProgress.linearProgressIndeterminate

  , RMWC.Blocks.Avatar.avatarImage { size: RMWC.Blocks.Avatar.Medium, url: Url.unsafeUrl "https://rmwc.io/images/avatars/blackwidow.png", name: "Natalia Alianovna Romanova", square: false, contain: false }
  , RMWC.Blocks.Avatar.avatarInitials { size: RMWC.Blocks.Avatar.Medium, name: "Natalia Alianovna Romanova", square: false, contain: false }

  -- | , RMWC.Blocks.Badge.inlineNoContent
  -- | , RMWC.Blocks.Badge.inlineWithContent [HH.text "22+"]

  -- | , RMWC.Blocks.Icon.iconLigature { name: "favorite", size: Nothing }
  -- | , RMWC.Blocks.Icon.iconComponent Nothing [ HH.div [ HP.style "background: green; width: 24px; height: 24px; border-radius: 100px;" ] [] ]

  -- | , RMWC.Blocks.Icon.iconLigature { name: "favorite", size: Just RMWC.Blocks.Icon.Xsmall }
  -- | , RMWC.Blocks.Icon.iconLigature { name: "favorite", size: Just RMWC.Blocks.Icon.Small }
  -- | , RMWC.Blocks.Icon.iconLigature { name: "favorite", size: Just RMWC.Blocks.Icon.Medium }
  -- | , RMWC.Blocks.Icon.iconLigature { name: "favorite", size: Just RMWC.Blocks.Icon.Large }
  -- | , RMWC.Blocks.Icon.iconLigature { name: "favorite", size: Just RMWC.Blocks.Icon.Xlarge }

  -- | , RMWC.Blocks.Icon.iconUrl { url: Url.unsafeUrl "https://rmwc.io/images/icons/twitter.png", size: Just RMWC.Blocks.Icon.Xlarge }

  -- | , RMWC.Blocks.Icon.iconComponent Nothing
  -- |   [ Halogen.SVG.Elements.svg
  -- |     [ Halogen.SVG.Attributes.viewBox 0.0 0.0 24.0 24.0
  -- |     , HP.style "width: 24px; height: 24px;"
  -- |     ]
  -- |     [ Halogen.SVG.Elements.path
  -- |       [ HP.attr (AttrName "fill") "#4285F4"
  -- |       , HP.attr (AttrName "d")
  -- |         "M21.35,11.1H12.18V13.83H18.69C18.36,17.64 15.19,19.27 12.19,19.27C8.36,19.27 5,16.25 5,12C5,7.9 8.2,4.73 12.2,4.73C15.29,4.73 17.1,6.7 17.1,6.7L19,4.72C19,4.72 16.56,2 12.1,2C6.42,2 2.03,6.8 2.03,12C2.03,17.05 6.16,22 12.25,22C17.6,22 21.5,18.33 21.5,12.91C21.5,11.76 21.35,11.1 21.35,11.1V11.1Z"
  -- |       ]
  -- |     ]
  -- |   ]
  ]

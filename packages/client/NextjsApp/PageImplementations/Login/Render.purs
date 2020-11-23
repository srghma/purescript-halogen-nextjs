module NextjsApp.PageImplementations.Login.Render where

import NextjsApp.PageImplementations.Login.Form (formComponent)
import NextjsApp.PageImplementations.Login.Types (Action(..), ChildSlots, LoginError(..), State)
import Protolude
import NextjsApp.PageImplementations.Login.Css as NextjsApp.PageImplementations.Login.Css

import Formless as F
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Login.Types (Action(..), ChildSlots, LoginError(..), State)
renderError :: Maybe LoginError -> String
renderError = maybe ""
  case _ of
       LoginError__UsernameOrEmailNotRegistered -> "Username or email not registered or not confirmed"
       LoginError__WrongPassword      -> "Wrong password"
       LoginError__UnknownError error -> "Unknown error: " <> error

render ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  State ->
  HH.ComponentHTML Action ChildSlots m
render = \state ->
  HH.div
    [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.root ]
    [ HH.text (renderError state.loginError)
    , HH.img
      [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.logo
      , HP.alt "logo"
      , HP.src purescriptLogoSrc
      ]
    , HH.slot F._formless unit formComponent unit Action__HandleLoginForm
    ]

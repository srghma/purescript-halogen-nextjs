module NextjsApp.PageImplementations.VerifyUserEmail.Render where

import NextjsApp.PageImplementations.VerifyUserEmail.Types (Action(..), ChildSlots, VerifyUserEmailError(..), State)
import Protolude
import NextjsApp.PageImplementations.VerifyUserEmail.Css as NextjsApp.PageImplementations.VerifyUserEmail.Css

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.VerifyUserEmail.Types (Action(..), ChildSlots, VerifyUserEmailError(..), State)

renderError :: VerifyUserEmailError -> String
renderError =
  case _ of
       VerifyUserEmailError__TokenExpired -> "Token is expired"
       VerifyUserEmailError__Unknown error -> "Unknown error: " <> error

render ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  State ->
  HH.ComponentHTML Action ChildSlots m
render = \state ->
  HH.div
    [ HP.class_ NextjsApp.PageImplementations.VerifyUserEmail.Css.styles.root ]
    [ HH.text (renderError state.verifyError)
    ]

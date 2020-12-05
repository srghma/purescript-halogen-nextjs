module NextjsApp.PageImplementations.Register.Form
  ( module NextjsApp.PageImplementations.Register.Form
  , module NextjsApp.PageImplementations.Register.Form.Types
  )
  where

import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Data.NonUsedUsername as NextjsApp.Data.NonUsedUsername
import Protolude

import Formless as F
import Halogen.Component as Halogen.Component
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Register.Form.Render (render)
import NextjsApp.PageImplementations.Register.Form.Types (FormChildSlots, RegisterDataValidated, RegisterForm(..), RegisterFormRow, UserAction(..), prx)
import NextjsApp.Data.MatchingPassword as NextjsApp.Data.MatchingPassword
import NextjsApp.Data.NonUsedEmail as NextjsApp.Data.NonUsedEmail

formComponent ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  F.Component RegisterForm (Const Void) FormChildSlots Unit RegisterDataValidated m
formComponent = F.component (const formInput) formSpec
  where
    formInput :: F.Input' RegisterForm m
    formInput =
      { initialInputs: Nothing -- same as: Just (F.wrapInputFields { name: "", age: "" })
      , validators: RegisterForm
        { password:             F.hoistFnE \form input -> NextjsApp.Data.MatchingPassword.fromString { current: input, expectedToEqualTo: F.getInput prx.passwordConfirmation form }
        , passwordConfirmation: F.hoistFnE \form input -> NextjsApp.Data.MatchingPassword.fromString { current: input, expectedToEqualTo: F.getInput prx.password form }
        , username:             F.hoistFnME_ \s -> liftAff $ NextjsApp.Data.NonUsedUsername.fromString s
        , email:                F.hoistFnME_ \s -> liftAff $ NextjsApp.Data.NonUsedEmail.fromString s
        }
      }

    formSpec :: forall input st . F.Spec RegisterForm st (Const Void) UserAction FormChildSlots input RegisterDataValidated m
    formSpec = F.defaultSpec
      { render = render >>> lmap (Halogen.Component.hoistSlot liftAff)
      , handleEvent = F.raiseResult
      , handleAction = handleAction
      }
      where

      handleAction ::
        UserAction ->
        F.HalogenM RegisterForm st UserAction FormChildSlots RegisterDataValidated m Unit
      handleAction =
        case _ of
             UserAction__Navigate route -> NextjsApp.Navigate.navigate route

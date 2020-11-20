module NextjsApp.PageImplementations.Login.Form
  ( module NextjsApp.PageImplementations.Login.Form
  , module NextjsApp.PageImplementations.Login.Form.Types
  )
  where

import Material.Classes.LayoutGrid
import NextjsApp.Data.Password
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Queries.IsUsernameOrEmailInUse
import NextjsApp.Queries.IsUsernameOrEmailInUse as NextjsApp.Queries.IsUsernameOrEmailInUse
import Protolude

import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import Data.Array as Array
import Data.Either (Either(..))
import Data.Int as Int
import Data.Lens.Record as Lens
import Data.Maybe (Maybe(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Variant (Variant, inj)
import Formless as F
import GraphQLClient as GraphQLClient
import Halogen as H
import Halogen.Component as Halogen.Component
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Login.Form.Render
import NextjsApp.PageImplementations.Login.Form.Types

formComponent ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  F.Component LoginForm (Const Void) FormChildSlots Unit LoginDataValidated m
formComponent = F.component (const formInput) formSpec
  where
    formInput :: F.Input' LoginForm m
    formInput =
      { initialInputs: Nothing -- same as: Just (F.wrapInputFields { name: "", age: "" })
      , validators: LoginForm
          { password: F.hoistFnE_ $ NextjsApp.Data.Password.fromString
          , usernameOrEmail: F.hoistFnME_ (\s -> liftAff $ NextjsApp.Queries.IsUsernameOrEmailInUse.fromString s)
          }
      }

    formSpec :: forall input st . F.Spec LoginForm st (Const Void) UserAction FormChildSlots input LoginDataValidated m
    formSpec = F.defaultSpec { render = render >>> lmap (Halogen.Component.hoistSlot liftAff), handleEvent = F.raiseResult, handleAction = handleAction }
      where

      handleAction ::
        UserAction ->
        F.HalogenM LoginForm st UserAction FormChildSlots LoginDataValidated m Unit
      handleAction =
        case _ of
             UserAction__RegisterButtonClick _ -> NextjsApp.Navigate.navigate NextjsApp.Route.Signup

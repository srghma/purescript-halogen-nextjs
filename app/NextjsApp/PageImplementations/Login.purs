module NextjsApp.PageImplementations.Login (component) where

import Protolude

import Api.Object.User as Api.Object.User
import Api.Query as Api.Query
import Api.Mutation as Api.Mutation
import Data.Array as Array
import Data.Either (Either(..))
import Data.Email (Email)
import Data.Email as Email
import Data.Int as Int
import Data.Lens.Record as Lens
import Data.Maybe (Maybe(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Variant (Variant, inj)
import Formless as F
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import Material.Classes.LayoutGrid
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import Halogen.Component as Halogen.Component
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.Data.Password (Password)
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.PageImplementations.Login.Types
import NextjsApp.PageImplementations.Login.Render
import GraphQLClient as GraphQLClient
import Api.Object.LoginPayload as Api.Object.LoginPayload
import NextjsApp.ApiUrl
import Api.Scalars
import Data.Array.NonEmpty as NonEmptyArray
import NextjsApp.ServerExceptions as NextjsApp.ServerExceptions

login :: { email :: Email, password :: Password } -> Aff (LoginError \/ Jwt)
login loginDataValidated = do
  response <-
      GraphQLClient.graphqlMutationRequest apiUrl GraphQLClient.defaultRequestOptions $
        Api.Mutation.login
          { input:
            { email: Email.toString loginDataValidated.email
            , password: NextjsApp.Data.Password.toString loginDataValidated.password
            , clientMutationId: GraphQLClient.Absent
            }
          }
          (Api.Object.LoginPayload.jwt)

  let (response' :: LoginError \/ Jwt) =
        case response of
            Left (GraphQLClient.GraphQLError__User details _) ->
              let message = NonEmptyArray.head details # unwrap # _.message
               in Left $
                  case unit of
                       _ | message == NextjsApp.ServerExceptions.login_emailNotRegistered -> LoginError__EmailNotRegistered
                         | message == NextjsApp.ServerExceptions.login_notConfirmed ->       LoginError__NotConfirmed
                         | message == NextjsApp.ServerExceptions.login_wrongPassword ->      LoginError__WrongPassword
                         | otherwise ->                                                      LoginError__UnknownError message
            Left error -> Left $ LoginError__UnknownError $ GraphQLClient.printGraphQLError error
            Right mjwt ->
              case join mjwt of
                    Nothing -> Left $ LoginError__UnknownError "no jwt"
                    Just jwt -> Right jwt
  pure response'

component ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  H.Component Query Input Message m
component =
  H.mkComponent
    { initialState: const initialState
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction =
              case _ of
                    Action__HandleLoginForm loginDataValidated -> do
                      traceM loginDataValidated

                      liftAff (login loginDataValidated) >>=
                        case _ of
                            Left error -> H.modify_ _ { loginError = Just error }
                            Right jwt -> pure unit

                      -- | setTokenBrowser(token)
                      -- | dispatch(stopSubmit(loginFormId))
                      -- | Router.pushRoute('index')
            }
    , render
    }
  where
    initialState :: State
    initialState = { loginError: Nothing }

module NextjsApp.PageImplementations.Login (component) where

import Api.Scalars
import Material.Classes.LayoutGrid
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.PageImplementations.Login.Render
import NextjsApp.PageImplementations.Login.Types
import Protolude

import Affjax as Affjax
import Api.Mutation as Api.Mutation
import Api.Object.LoginPayload as Api.Object.LoginPayload
import Api.Object.User as Api.Object.User
import Api.Query as Api.Query
import Browser.Cookie as Browser.Cookie
import Data.Argonaut.Decode as Data.Argonaut.Decode
import Data.Array as Array
import Data.Array.NonEmpty as NonEmptyArray
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
import NextjsApp.Data.Password (Password)
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.ServerExceptions as NextjsApp.ServerExceptions

login :: { email :: Email, password :: Password } -> Aff (LoginError \/ Jwt)
login loginDataValidated = do
  response <-
      GraphQLClient.graphqlMutationRequest NextjsApp.NodeEnv.apiUrl GraphQLClient.defaultRequestOptions $
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
            Left error -> Left $
              case error of
                   GraphQLClient.GraphQLError__Affjax affjaxError -> LoginError__UnknownError $ Affjax.printError affjaxError
                   GraphQLClient.GraphQLError__UnexpectedPayload decodeError _jsonBody -> LoginError__UnknownError $ Data.Argonaut.Decode.printJsonDecodeError decodeError
                   GraphQLClient.GraphQLError__User details _pissiblyParsedData ->
                     let message = NonEmptyArray.head details # unwrap # _.message
                      in case unit of
                              _ | message == NextjsApp.ServerExceptions.login_emailNotRegistered -> LoginError__EmailNotRegistered
                                | message == NextjsApp.ServerExceptions.login_notConfirmed ->       LoginError__NotConfirmed
                                | message == NextjsApp.ServerExceptions.login_wrongPassword ->      LoginError__WrongPassword
                                | otherwise ->                                                      LoginError__UnknownError message
            Right mjwt ->
              case join mjwt of
                    Nothing -> Left $ LoginError__UnknownError "Unexpected payload: no JWT"
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
                            Right jwt -> do
                               liftEffect $ Browser.Cookie.setCookie $ Browser.Cookie.SetCookie
                                { cookie: Browser.Cookie.Cookie
                                  { key: NextjsApp.NodeEnv.jwtKey
                                  , value: unwrap jwt
                                  }
                                , opts: Just $ Browser.Cookie.CookieOpts
                                  { maxAge: Just NextjsApp.NodeEnv.jwtMaxAgeInSeconds
                                  , expires: Nothing -- instead of date of expiration, we will use maxAge instead
                                  , secure: NextjsApp.NodeEnv.isProduction

                                  -- | disallow access from js (in case app has XSS vulnerabilities)
                                  -- | check https://medium.com/@ryanchenkie_40935/react-authentication-how-to-store-jwt-in-a-cookie-346519310e81
                                  -- | TODO: csrf
                                  -- |
                                  -- | because for security reasons cookies should be stored either
                                  -- | - in memory
                                  -- | - in httpOnly cookies (we use)
                                  , httpOnly: true

                                  -- TODO:
                                  -- Nothing (default in old browsers) - allow cors
                                  -- Just Strict - disallow
                                  -- Just Lax (default in new browsers) - disallow, except for links in <a>
                                  , samesite: Nothing

                                  , domain: NextjsApp.NodeEnv.jwtDomain
                                  , path: Nothing -- same as Just "/" ?
                                  }
                                }

                               NextjsApp.Navigate.navigate NextjsApp.Route.Secret
            }
    , render
    }
  where
    initialState :: State
    initialState = { loginError: Nothing }

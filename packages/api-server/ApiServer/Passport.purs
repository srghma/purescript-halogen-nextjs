module ApiServer.Passport where

import Node.Express.Handler
import Node.Express.Passport
import Node.Express.Types
import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.Time.Duration (Days(..))
import Data.Time.Duration as Duration
import Database.PostgreSQL (Pool)
import Node.Express.Passport as Passport
import Node.Express.Response as Express
import PassportGithub as PassportGithub
import Type.Prelude (Proxy(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed

passportMiddlewareAndRoutes :: _ -> Effect { middlewares :: Array Middleware, routes :: Array (Tuple String Handler) }
passportMiddlewareAndRoutes config = do
  (passport :: Passport) <- Passport.getPassport

  ApiServer.PassportMethodsFixed.passportMethods.addSerializeUser passport \req user -> undefined
  ApiServer.PassportMethodsFixed.passportMethods.addDeserializeUser passport \req json -> pure undefined

  let githubCallbackPath = "/auth/github/callback"

  Passport.useStrategy passport PassportGithub.githubStrategyId $
    ApiServer.PassportMethodsFixed.passportMethods.passportStrategyGithub
    { clientID: config.oauthGithubClientID
    , clientSecret: NonEmptyString.toString config.oauthGithubClientSecret
    , includeEmail: true
    , callbackURL: config.rootUrl <> githubCallbackPath
    }
    \request accesstoken refreshtoken params profile -> undefined

  let (githubHandler :: Handler) =
        ApiServer.PassportMethodsFixed.passportMethods.authenticate
        passport
        PassportGithub.githubStrategyId
        ( Passport.defaultAuthenticateOptions
          { failureRedirect = Just "/login"
          , successReturnToOrRedirect = Just "/" -- use `req.session.returnTo` or fallback
          }
        )
        Nothing

  pure
    { middlewares:
      [ Passport.passportInitialize passport Passport.defaultPassportInitializeOptions
      , Passport.passportSession passport Passport.defaultPassportSessionOptions
      ]
    , routes:
      [ "/logout" /\ do
          Passport.logOut
          Express.redirect "/"
      , "/auth/github" /\ do
          undefined -- setReturnTo
      , githubCallbackPath /\ githubHandler
      ]
    }

module ApiServer.Passport where

import NextjsApp.NodeEnv
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

passportMethods =
  let
    proxyUser :: Proxy String
    proxyUser = Proxy

    proxyInfo :: Proxy Void
    proxyInfo = Proxy
  in
    { addSerializeUser: Passport.addSerializeUser proxyUser
    , addDeserializeUser: Passport.addDeserializeUser proxyUser
    , authenticate: Passport.authenticate proxyUser proxyInfo
    , passportStrategyGithub: PassportGithub.passportStrategyGithub proxyUser proxyInfo
    }

passportMiddlewareAndRoutes :: _ -> Effect { middlewares :: Array Middleware, routes :: Array (Tuple String Handler) }
passportMiddlewareAndRoutes config = do
  (passport :: Passport) <- Passport.getPassport

  passportMethods.addSerializeUser passport \req user -> undefined
  passportMethods.addDeserializeUser passport \req json -> pure undefined

  let githubCallbackPath = "/auth/github/callback"

  Passport.useStrategy passport PassportGithub.githubStrategyId $
    passportMethods.passportStrategyGithub
    { clientID: config.oauthGithubClientID
    , clientSecret: NonEmptyString.toString config.oauthGithubClientSecret
    , includeEmail: true
    , callbackURL: config.rootUrl <> githubCallbackPath
    }
    \request accesstoken refreshtoken params profile -> undefined

  let (githubHandler :: Handler) =
        passportMethods.authenticate
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

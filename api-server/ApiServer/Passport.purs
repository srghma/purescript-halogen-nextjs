module ApiServer.Passport where

import NextjsApp.NodeEnv
import Node.Express.Passport
import Node.Express.Types
import Protolude

import Data.Time.Duration (Days(..))
import Data.Time.Duration as Duration
import Database.PostgreSQL (Pool)
import Node.Express.Handler (HandlerM(..))
import Node.Express.Passport as Passport
import Node.Express.Response (redirect)
import Node.Express.Response as Express
import PassportGithub as PassportGithub
import Type.Prelude (Proxy(..))

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

passport :: _ -> _
passport { githubKey, githubSecretKey, rootUrl, rootPgPool } = do
  passport <- Passport.getPassport

  passportMethods.addSerializeUser passport \req user -> undefined
  passportMethods.addDeserializeUser passport \req json -> pure undefined

  let githubCallbackPath = "/auth/" <> unwrap PassportGithub.githubStrategyId <> "/callback"

  Passport.useStrategy passport PassportGithub.githubStrategyId $
    passportMethods.passportStrategyGithub
    { clientId: githubKey
    , clientSecret: githubSecretKey
    , includeEmail: true
    , callbackURL: rootUrl <> githubCallbackPath
    }
    \request accesstoken refreshtoken params profile -> undefined

  let (githubHandler :: HandlerM Unit) =
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
      , ("/auth/" <> unwrap PassportGithub.githubStrategyId) /\ do
          undefined -- setReturnTo
      , githubCallbackPath /\ githubHandler
      ]
    }

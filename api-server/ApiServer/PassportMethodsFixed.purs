module ApiServer.PassportMethodsFixed where

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
    , getUser: Passport.getUser proxyUser
    , logIn: Passport.logIn proxyUser
    , passportStrategyGithub: PassportGithub.passportStrategyGithub proxyUser proxyInfo
    }

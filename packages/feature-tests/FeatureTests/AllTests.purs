module Test.AllTests where

import Prelude
import Test.Spec (describe)
import Lib.FeatureTest (FeatureTestSpecInternal, it, itOnly)
import FeatureTests.Login.SuccessSpec as FeatureTests.Login.SuccessSpec
import FeatureTests.Login.ErrorNotConfirmedSpec as FeatureTests.Login.ErrorNotConfirmedSpec
import FeatureTests.Register.SuccessSpec as FeatureTests.Register.SuccessSpec

allTests :: FeatureTestSpecInternal Unit
allTests = do
  describe "login" do
    itOnly "success" FeatureTests.Login.SuccessSpec.spec
    it "error not confirmed" FeatureTests.Login.ErrorNotConfirmedSpec.spec
  describe "register" do
    it "success" FeatureTests.Register.SuccessSpec.spec

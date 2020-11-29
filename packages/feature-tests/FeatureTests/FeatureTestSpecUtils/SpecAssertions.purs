module FeatureTests.FeatureTestSpecUtils.SpecAssertions where

import Protolude
import Test.Spec.Assertions as Spec
import Run (Run)
import Run as Run

-- rethrow all Effect and Aff errors with
shouldEqual = \x y -> do
  Run.liftEffect (try $ Spec.shouldEqual x y)


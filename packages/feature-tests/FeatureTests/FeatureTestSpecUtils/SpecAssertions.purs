module FeatureTests.FeatureTestSpecUtils.SpecAssertions where

import Protolude
import Test.Spec.Assertions as Spec
import Run (Run)
import Run as Run

shouldEqual = \x y -> Run.liftEffect (Spec.shouldEqual x y)


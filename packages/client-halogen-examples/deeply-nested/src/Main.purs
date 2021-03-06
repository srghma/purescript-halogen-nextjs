module Example.DeeplyNested.Main where

import Prelude

import Effect (Effect)
import Example.DeeplyNested.A as A
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI A.component unit body

module Worker.Main where

import Protolude
import Worker.Config as Config

main :: Effect Unit
main = do
  config <- Config.config
  pure unit

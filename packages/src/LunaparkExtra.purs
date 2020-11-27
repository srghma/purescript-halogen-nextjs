module LunaparkExtra where

import Protolude

import Lunapark as Lunapark
import Run (Run(..))

inputField :: forall r. Lunapark.Locator -> String -> Run ( lunapark :: Lunapark.LUNAPARK | r) Unit
inputField locator s = do
  element ← Lunapark.findElement locator
  Lunapark.clearElement element
  -- | Lunapark.moveTo { origin: Lunapark.FromElement element, x: 0, y: 0, duration: Milliseconds 1000.0 }
  -- | Lunapark.click
  Lunapark.sendKeysElement element s
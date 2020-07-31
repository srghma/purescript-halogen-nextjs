module RMWC.Blocks.CircularProgress where

import Protolude (Maybe, maybe, ($), (<>))

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Material.Classes.Button (mdc_button, mdc_button__icon, mdc_button__label, mdc_button__ripple)
import MaterialIconsFont.Classes (material_icons)
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA

size_xsmall :: Int
size_xsmall = 18
size_small :: Int
size_small =  20
size_medium :: Int
size_medium = 24
size_large :: Int
size_large =  36
size_xlarge :: Int
size_xlarge = 48

type CircularProgress =
  { min      :: Maybe Int
  , max      :: Maybe Int
  , progress :: Maybe Int
  , size     :: Int
  }

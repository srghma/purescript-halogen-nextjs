module SimpleXMLWithIndentation where

import Protolude
import Data.String.Yarn as String
import Data.String.Common as String

indent :: String -> String
indent x = "  " <> x

unlinesIndent :: Array String -> String
unlinesIndent = String.unlines <<< map indent

tagStart x = "<" <> x <> ">"

tagEnd x = "</" <> x <> ">"

printProp (name /\ val) = name <> "=\"" <> val <> "\""

printProps = String.joinWith " " <<< map printProp

tagOneline :: String -> Array (String /\ String) -> String -> String
tagOneline tagName props content = tagStart (tagName <> " " <> printProps props) <> content <> tagEnd tagName

tagMultiLine :: String -> Array (String /\ String) -> Array String -> String
tagMultiLine tagName props content = String.unlines $ [ tagStart (tagName <> " " <> printProps props), unlinesIndent content, tagEnd tagName ]


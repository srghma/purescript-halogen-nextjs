module NextjsApp.Template where

import Protolude
import Data.String.Yarn as String
import Data.String.Common as String

data TargetData
  = TargetData__Mobile
  | TargetData__Server
    { prerenderedHtml :: String
    , prerenderedPagesManifest :: String
    , prerenderedPageData :: Maybe String
    }

type TemplateConfig =
  { title :: String
  , targetData :: TargetData
  , headTags :: Array String
  , bodyTags :: Array String
  }

template :: TemplateConfig -> String
template { targetData, title, headTags, bodyTags } =
  let
    meta =
      case targetData of
           TargetData__Server _ -> """<meta name="viewport" content="initial-scale=1,width=device-width"/>"""
           TargetData__Mobile ->
              let
                  cordovaSecurityPolicyContent =
                    -- Customize this policy to fit your own app's needs. For more guidance, see:
                    --     https://github.com/apache/cordova-plugin-whitelist/blob/master/README.md#content-security-policy
                    -- Some notes:
                    --     * gap: is required only on iOS (when using UIWebView) and is needed for JS->native communication
                    --     * https://ssl.gstatic.com is required only on Android and is needed for TalkBack to function properly
                    --     * Disables use of inline scripts in order to mitigate risk of XSS vulnerabilities. To change this:
                    --         * Enable inline JS: add 'unsafe-inline' to default-src

                    String.joinWith "; "
                    [ "default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'"
                    , "style-src 'self' 'unsafe-inline'"
                    , "media-src *"
                    , "img-src 'self' data: content:"
                    , "connect-src *" -- connect-src * allows to fetch() any url
                    ]

                  cordovaSecurityPolicy = "<meta http-equiv=\"Content-Security-Policy\" content=\"" <> cordovaSecurityPolicyContent <> "\">"
               in String.unlines
                  [ cordovaSecurityPolicy
                  , """<meta name="format-detection" content="telephone=no">"""
                  , """<meta name="msapplication-tap-highlight" content="no">"""
                  , """<meta name="viewport" content="initial-scale=1,width=device-width,viewport-fit=cover">"""
                  ]

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
  in String.unlines
    [ "<!DOCTYPE html>"
    , tagMultiLine "html" []
      [ tagMultiLine "head" [] $
        [ meta
        , """<meta charset="utf-8"/>"""
        , tagOneline "title" [] title
        , """<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">"""
        , """<link href="https://fonts.googleapis.com/css?family=Material+Icons&display=block" rel="stylesheet">"""
        ]
        <> headTags
      , tagMultiLine "body" [ "class" /\ "mdc-typography mdc-theme--background" ] $
          [ tagOneline "div" [ "id" /\ "root" ] $
            case targetData of
                 TargetData__Server serverData -> serverData.prerenderedHtml
                 TargetData__Mobile -> ""
          , case targetData of
                 TargetData__Server serverData ->
                   String.unlines
                    [ """<script id="__PAGES_MANIFEST__" type="application/json">""" <> serverData.prerenderedPagesManifest <> "</script>"
                    , case serverData.prerenderedPageData of
                          Nothing -> ""
                          Just prerenderedPageData -> """<script id="__PAGE_DATA__" type="application/json">""" <> prerenderedPageData <> "</script>"
                    ]
                 TargetData__Mobile -> """<script type="text/javascript" src="cordova.js"></script>"""
          ]
          <> bodyTags
      ]
    ]

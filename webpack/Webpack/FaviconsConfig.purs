module Webpack.FaviconsConfig where

import Protolude

import Data.Nullable (Nullable)
import Data.Nullable (null) as Nullable

type FaviconsConfig =
  { path                        :: String   -- Path for overriding default icons path. `string`
  , appName                     :: String   -- Your application's name. `string`
  , appShortName                :: String   -- Your application's short_name. `string`. Optional. If not set, appName will be used
  , appDescription              :: String   -- Your application's description. `string`
  , developerName               :: Nullable String                -- Your (or your developer's) name. `string`
  , developerURL                :: Nullable String                -- Your (or your developer's) URL. `string`
  , dir                         :: String   -- Primary text direction for name, short_name, and description
  , lang                        :: String   -- Primary language for name and short_name
  , background                  :: String   -- Background colour for flattened icons. `string`
  , theme_color                 :: String   -- Theme color user for example in Android's task switcher. `string`
  , appleStatusBarStyle         :: String   -- Style for Apple status bar: "black-translucent", "default", "black". `string`
  , display                     :: String   -- Preferred display mode: "fullscreen", "standalone", "minimal-ui" or "browser". `string`
  , orientation                 :: String   -- Default orientation: "any", "natural", "portrait" or "landscape". `string`
  , scope                       :: String   -- set of URLs that the browser considers within your app
  , start_url                   :: String   -- Start URL when launching the application from a device. `string`
  , version                     :: String   -- Your application's version string. `string`
  , logging                     :: Boolean  -- Print logs to console? `boolean`
  , pixel_art                   :: Boolean  -- Keeps pixels "sharp" when scaling up, for pixel art.  Only supported in offline mode.
  , loadManifestWithCredentials :: Boolean  -- Browsers don't send cookies when fetching a manifest, enable this to fix that. `boolean`
  , icons                       ::
      -- Platform Options:
      -- - offset - offset in percentage
      -- - background:
      --   * false - use default
      --   * true - force use default, e.g. set background for Android icons
      --   * color - set background for the specified icons
      --   * mask - apply mask in order to create circle icon (applied by default for firefox). `boolean`
      --   * overlayGlow - apply glow effect after mask has been applied (applied by default for firefox). `boolean`
      --   * overlayShadow - apply drop shadow after mask has been applied .`boolean`
      { android                   :: Boolean -- Create Android homescreen icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , appleIcon                 :: Boolean -- Create Apple touch icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , appleStartup              :: Boolean -- Create Apple startup images. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , coast                     :: Boolean -- Create Opera Coast icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , favicons                  :: Boolean -- Create regular favicons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , firefox                   :: Boolean -- Create Firefox OS icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , windows                   :: Boolean -- Create Windows 8 tile icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , yandex                    :: Boolean -- Create Yandex browser icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      }
  }


faviconsConfig :: FaviconsConfig
faviconsConfig =
  { path:                        "/"
  , appName:                     "Nextjs example app"
  , appShortName:                "Nextjs"
  , appDescription:              "Example application for the best framework"
  , developerName:               Nullable.null
  , developerURL:                Nullable.null
  , dir:                         "auto"
  , lang:                        "en-US"
  , background:                  "#fff"
  , theme_color:                 "#fff"
  , appleStatusBarStyle:         "black-translucent"
  , display:                     "standalone"
  , orientation:                 "any"
  , scope:                       "/"
  , start_url:                   "/"
  , version:                     "1.0"
  , logging:                     false
  , pixel_art:                   false
  , loadManifestWithCredentials: false
  , icons:
    { android:      false
    , appleIcon:    false
    , appleStartup: false
    , coast:        false
    , favicons:     true
    , firefox:      false
    , windows:      false
    , yandex:       false
    }
  }

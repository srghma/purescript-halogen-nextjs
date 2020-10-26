{ name = "halogen-mdl"
, dependencies =
  [ "ace"
  , "aff-coroutines"
  , "affjax"
  , "ansi"
  , "argonaut-codecs"
  , "argonaut-generic"
  , "arrays"
  , "codec"
  , "console"
  , "debug"
  , "effect"
  , "event"
  , "filterable"
  , "generics-rep"
  , "halogen"
  , "halogen-css"
  , "halogen-select"
  , "halogen-storybook"
  , "halogen-hooks"
  , "halogen-hooks-extra"
  , "halogen-formless"
  , "halogen-vdom-string-renderer"
  , "halogen-material-components-web"
  , "halogen-svg"
  , "hyper"
  , "js-timers"
  , "node-process"
  , "numbers"
  , "optparse"
  , "prelude"
  , "protolude"
  , "psci-support"
  , "record"
  , "routing-duplex"
  , "strings"
  , "tuples"
  , "web-socket"
  , "yarn"
  , "web-intersection-observer"
  , "aff-promise"
  , "pathy"
  , "webpack-loader-api"
  , "codec-argonaut"
  , "profunctor"
  , "newtype"
  , "homogeneous-records"
  , "record-extra"
  , "record-extra-srghma"
  , "node-url"
  , "foreign-generic"
  , "stringutils"
  , "foreign-js-map"
  , "node-child-process"
  , "graphql-client"
  , "browser-cookies"
  ]
, packages = ./packages.dhall
, sources =
  [ "app/**/*.purs"
  , "src/**/*.purs"
  , "test/**/*.purs"
  , "api-server/**/*.purs"
  , "webpack/**/*.purs"
  , "examples/ace/**/*.purs"
  , "examples/basic/**/*.purs"
  , "examples/components-inputs/**/*.purs"
  , "examples/components-multitype/**/*.purs"
  , "examples/components/**/*.purs"
  , "examples/effects-aff-ajax/**/*.purs"
  , "examples/effects-effect-random/**/*.purs"
  , "examples/higher-order-components/**/*.purs"
  , "examples/interpret/**/*.purs"
  , "examples/keyboard-input/**/*.purs"
  , "examples/lifecycle/**/*.purs"
  , "examples/deeply-nested/**/*.purs"
  , "examples/text-nodes/**/*.purs"
  , "examples/dynamic-input/**/*.purs"
  , "examples/lazy/**/*.purs"
  ]
}

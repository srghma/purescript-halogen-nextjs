{ name = "halogen-mdl-client"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "packages/client/**/*.purs"
  , "src/**/*.purs"
  , "test/**/*.purs"
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

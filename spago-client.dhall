{ name = "halogen-mdl-client"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "./packages/client/**/*.purs"
  , "./packages/client-test/**/*.purs"
  , "./packages/client-webpack/**/*.purs"
  , "./packages/src/**/*.purs"
  , "./packages/api-server-exceptions/**/*.purs"
  , "./packages/client-halogen-examples/ace/**/*.purs"
  , "./packages/client-halogen-examples/basic/**/*.purs"
  , "./packages/client-halogen-examples/components-inputs/**/*.purs"
  , "./packages/client-halogen-examples/components-multitype/**/*.purs"
  , "./packages/client-halogen-examples/components/**/*.purs"
  , "./packages/client-halogen-examples/effects-aff-ajax/**/*.purs"
  , "./packages/client-halogen-examples/effects-effect-random/**/*.purs"
  , "./packages/client-halogen-examples/higher-order-components/**/*.purs"
  , "./packages/client-halogen-examples/interpret/**/*.purs"
  , "./packages/client-halogen-examples/keyboard-input/**/*.purs"
  , "./packages/client-halogen-examples/lifecycle/**/*.purs"
  , "./packages/client-halogen-examples/deeply-nested/**/*.purs"
  , "./packages/client-halogen-examples/text-nodes/**/*.purs"
  , "./packages/client-halogen-examples/dynamic-input/**/*.purs"
  , "./packages/client-halogen-examples/lazy/**/*.purs"
  ]
}

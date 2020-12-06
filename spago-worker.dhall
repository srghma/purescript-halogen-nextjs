{ name = "worker"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "./packages/src/**/*.purs"
  , "./packages/worker/**/*.purs"
  ]
}

{ name = "all"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "./packages/**/*.purs"
  ]
}

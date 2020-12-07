{ name = "worker"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "./packages/src/**/*.purs"
  , "./packages/worker/**/*.purs"
  , "./packages/client/NextjsApp/AppM.purs"
  , "./packages/client/NextjsApp/Route.purs"
  , "./packages/client/NextjsApp/Link/Types.purs"
  ]
}

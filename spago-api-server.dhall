{ name = "api-server"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "./packages/src/**/*.purs"
  , "./packages/api-server/**/*.purs"
  , "./packages/api-server-exceptions/**/*.purs"
  , "./packages/api-server-config/**/*.purs"
  , "./packages/client/NextjsApp/AppM.purs"
  , "./packages/client/NextjsApp/Route.purs"
  , "./packages/client/NextjsApp/Link/Types.purs"
  ]
}

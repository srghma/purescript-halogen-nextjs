{ name = "halogen-mdl-api-server"
, dependencies = ./dependencies.dhall
, packages = ./packages.dhall
, sources =
  [ "src/**/*.purs"
  , "api-server/**/*.purs"
  , "app/NextjsApp/AppM.purs"
  , "app/NextjsApp/Route.purs"
  , "app/NextjsApp/Link/Types.purs"
  ]
}

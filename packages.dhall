let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20201007/packages.dhall sha256:35633f6f591b94d216392c9e0500207bb1fec42dd355f4fecdfd186956567b6b

in  (     upstream
      //  https://raw.githubusercontent.com/srghma/my-purescript-package-sets/70e44c9/packages.dhall sha256:00b262416a9624a652b17670683fe6937ecdb8744c7d08a3dc95630956cfe173
            upstream.(https://raw.githubusercontent.com/srghma/my-purescript-package-sets/70e44c9/upstreamTypeChunk.dhall sha256:8a4543a6ab82a4873958510d701ebeaa6dc1729634f70871299b35e535b6a3cd)
    )
  with affjax.version = "v11.0.0"

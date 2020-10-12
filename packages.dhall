let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20201007/packages.dhall sha256:35633f6f591b94d216392c9e0500207bb1fec42dd355f4fecdfd186956567b6b

in  (
    upstream
    //  https://raw.githubusercontent.com/srghma/my-purescript-package-sets/a3ca2f1/packages.dhall sha256:2832dc42620ebf7ab2603629aeb87d2d5143b1395787ca0208d70174d17b04c3
          upstream.(https://raw.githubusercontent.com/srghma/my-purescript-package-sets/a3ca2f1/upstreamTypeChunk.dhall sha256:8a4543a6ab82a4873958510d701ebeaa6dc1729634f70871299b35e535b6a3cd)
    )
    with affjax.version = "v11.0.0"

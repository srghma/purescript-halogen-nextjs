let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200922/packages.dhall sha256:5edc9af74593eab8834d7e324e5868a3d258bbab75c5531d2eb770d4324a2900

let overrides = {=}

let additions = {=}

in      upstream
    //  https://raw.githubusercontent.com/srghma/my-purescript-package-sets/cfb9d0d/packages.dhall sha256:a8a17ee06f9ecc1fa0700608d67ef00644467a30e417437ba547d2d504bd2493
          upstream.(https://raw.githubusercontent.com/srghma/my-purescript-package-sets/cfb9d0d/upstreamTypeChunk.dhall sha256:8a4543a6ab82a4873958510d701ebeaa6dc1729634f70871299b35e535b6a3cd)
    //  overrides
    //  additions

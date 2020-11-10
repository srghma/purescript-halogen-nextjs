let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20201021/packages.dhall

in  ( upstream
    ⫽ /home/srghma/projects/my-purescript-package-sets/packages.dhall
        upstream.(/home/srghma/projects/my-purescript-package-sets/upstreamTypeChunk.dhall)
        )
    with affjax.version = "v11.0.0"

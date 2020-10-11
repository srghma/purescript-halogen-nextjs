{
  pkgs ? import ./nix/pkgs.nix
}:

# let
#   inherit (import ./default.nix {}) rootYarnModules;
# in

pkgs.mkShell rec {
  buildInputs = with pkgs; [
    pkgs.path # nixpkgs path, not dependency, add nixpkgs source to gc-root and prevent it to be gc collected
    # rootYarnModules

    gnumake
    git
    nix
    arion
    yarn2nix.yarn2nix
    docker
    docker-compose
    docker-volume-rm-if-exists

    nodejs
    yarn

    # for building c++ extensions (from https://matrix.ai/2018/03/24/developing-with-nix/)
    nodePackages.node-gyp
    nodePackages.node-gyp-build
    nodePackages.node-pre-gyp

    waitforit
    wait-for-postgres
    shmig
    db-tests-prepare
    pg_prove

    (import ./dev-commands/all-commands.nix { inherit pkgs; })
  ];

  # TODO: return
  # NIX_PATH = pkgs.lib.concatStringsSep ":" [
  #   "nixpkgs=${toString pkgs.path}"
  # ];

  # HISTFILE = toString ./.bash_hist;
  # CHROMEDRIVER_SKIP_DOWNLOAD = "true";

  # export PATH="${pkgs.rootProjectDir}/node_modules/.bin/:/home/srghma/projects/purescript/.stack-work/install/x86_64-linux-nix/ec68e55b45064aeed36ab3915e14fec1f60a3e92e42a196c7c6c1d57d1e2655d/8.6.5/bin/:$PATH"
  # shellHook = ''
  #   export PATH="${pkgs.rootProjectDir}/node_modules/.bin/:$PATH"
  # '';
}

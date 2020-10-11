# force Linux packages, useful for building packages that will be used inside docker on macos machine (docker on mac really uses Linux virtual machine)

let
  nixpkgs = import ./nixpkgs;

  system = "x86_64-linux";

  config = {
    allowUnfree = true;

    crossSystem = {
      config = system;
      platform = (import "${nixpkgs}/lib").systems.platforms.selectBySystem system;
    };
  };

  overlays = import ./overlays.nix;
in import nixpkgs { inherit system config overlays; }

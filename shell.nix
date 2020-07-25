{ pkgs ? import <nixpkgs> {} }:

# from
# https://specific.solutions.limited/projects/hanging-plotter/android-environment.md
# https://nixos.wiki/wiki/Android
let
  nixpkgsMaster = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/master.tar.gz") { config = { allowUnfree = true; android_sdk.accept_license = true; }; };

  androidSdk = nixpkgsMaster.pkgs.androidenv.androidPkgs_9_0.androidsdk;

  sdk_path = if pkgs.stdenv.isDarwin
    then "/Library/Android/sdk"
    else "/Android/Sdk"; # intentional Capital S
in
  pkgs.mkShell rec {
    buildInputs = with pkgs; [
      androidSdk
      nixpkgsMaster.pkgs.android-studio
      nixpkgsMaster.pkgs.jdk
      nixpkgsMaster.pkgs.glibc
      # nixpkgsMaster.pkgs.nodePackages.cordova
      nixpkgsMaster.pkgs.gradle
      nixpkgsMaster.pkgs.openjdk

      (writeScriptBin "patch-aapt2" ''
        echo patching aapt2 locations:
        find ~/.gradle -name aapt2 -executable -type f \
          -print \
          -exec patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 {} \;
      '')
    ];

    # override the aapt2 that gradle uses with the nix-shipped version
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/28.0.3/aapt2";

    USE_CCACHE        = 1;
    # ANDROID_JAVA_HOME = pkgs.jdk.home;
    # ANDROID_HOME      = "~/.androidsdk";

    ANDROID_SDK_ROOT=builtins.getEnv("HOME") + sdk_path;
    ANDROID_HOME=ANDROID_SDK_ROOT;

    LD_LIBRARY_PATH = pkgs.stdenv.lib.makeLibraryPath [
      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
    ];

    # shellHook = ''
    #   export GRADLE_USER_HOME=$(mktemp -d)
    #   export ANDROID_SDK_ROOT=${androidSdk}/libexec/android-sdk
    #   export ANDROID_HOME=${androidSdk}/libexec
    #   export ANDROID_SDK_HOME=$(mktemp -d)
    #   export PATH="$ANDROID_SDK_ROOT/bin:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/28.0.3:$PATH"
    # '';
  }

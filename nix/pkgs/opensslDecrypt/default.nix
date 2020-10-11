{ pkgs, ... }:

keyFile: name: ciphertext:
  pkgs.lib.removeSuffix "\n" (
    builtins.readFile (
      pkgs.runCommand name {} ''
        echo "${ciphertext}" | \
        ${pkgs.openssl}/bin/openssl enc -aes-256-cbc -a -d -kfile "${keyFile}" -out "$out"
      ''
    )
  )

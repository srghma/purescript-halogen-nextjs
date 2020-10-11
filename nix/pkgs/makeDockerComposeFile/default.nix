{ pkgs, ... }:

expression:

pkgs.writeTextFile {
  name = "docker-compose.yaml";
  text = builtins.toJSON expression; # yaml is subset of json
}

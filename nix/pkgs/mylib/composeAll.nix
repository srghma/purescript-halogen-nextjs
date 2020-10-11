{ lib, ... }:

with lib;

let

compose = f: g: x: f (g x);
id = x: x;
composeAll = builtins.foldl' compose id;

in

composeAll

{ lib, ... }:

with lib;

/*
  Merges list of records

  - if all values to merge are records - merge them recursively
  - if all values to merge are arrays - concatenate arrays
  - If values can't be merged - the latter value is preferred

  Example 1:
    recursiveMerge [
      { a = "x"; c = "m"; list = [1]; }
      { a = "y"; b = "z"; list = [2]; }
    ]

    returns

    { a = "y"; b = "z"; c="m"; list = [1 2] }

  Example 2:
    recursiveMerge [
      {
        a.b = [1];
        a.c = 1;
        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/hda";
      }
      {
        a.b = [2];
        a.c = 2;
        boot.loader.grub.device = "";
      }
    ]

    returns

    {
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "";
    }

  Example 3:
    recursiveMerge [{ a = ["x"]; b = ["x"]; } { a = ["y"]; b = ["x"]; }]

    returns

    { a = [ "x" "y" ]; b = [ "x" ]; }

  Example 4:
    recursiveMerge [{ a = ["x"]; b = ["z"]; } { a = ["y"]; b = "x"; }]

    returns

    { a = [ "x" "y" ]; b = "x"; }

*/

let

recursiveMerge = attrList:
  let f = attrPath:
    zipAttrsWith (n: values:
      if tail values == []
      then head values
      else
        if all isList values
        then unique (concatLists values)
        else
          if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values
    );
  in f [] attrList;

in

recursiveMerge

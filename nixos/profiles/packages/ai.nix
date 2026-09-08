{ pkgs }:

builtins.attrValues {
  inherit (pkgs)
    fabric-ai
    opencode
  ;
}

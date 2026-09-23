{ lib, ... }:

{
  imports = [
    ./modules/nixpkgs.nix
    ./modules/packages.nix
  ];

  home = {
    username = lib.mkDefault "aristide";
    homeDirectory = lib.mkDefault "/home/aristide";
    stateVersion = "25.11";
  };
}
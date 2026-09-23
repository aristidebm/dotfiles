{ lib, ... }:

{
  imports = [
    ./modules/nixpkgs.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/mango.nix
    ./modules/dbus.nix
    ./modules/containers.nix
    ./modules/portal.nix
  ];

  home = {
    username = lib.mkDefault "aristide";
    homeDirectory = lib.mkDefault "/home/aristide";
    stateVersion = "25.11";
  };
}
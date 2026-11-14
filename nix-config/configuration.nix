{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/default.nix
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Required by home-manager's xdg.portal assertion when
  # home-manager.useUserPackages is enabled, so portal definitions and
  # desktop-entry files from the user profile get linked into the system env.
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}

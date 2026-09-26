# The mangowm overlay patches xdg-desktop-portal-wlr to include `mango` in its
# UseIn list so screencast portal works under mangowm. Declaring it here (in
# home-manager's own pkgs, both NixOS and standalone) keeps it portable.
{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import ../overlays/mango-portal-fix.nix)
  ];
}
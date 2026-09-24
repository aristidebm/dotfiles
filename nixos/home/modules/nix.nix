{ lib, pkgs, ... }:

{
  nix.package = lib.mkDefault pkgs.nix;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

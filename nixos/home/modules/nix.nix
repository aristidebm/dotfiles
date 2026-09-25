{ lib, pkgs, ... }:

{
  nix.package = lib.mkDefault pkgs.nix;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # The pre-HM-managed ~/.config/nix/nix.conf (with max-jobs = auto, the Nix
  # default) must be overwritten on first activation.
  xdg.configFile."nix/nix.conf".force = true;
}

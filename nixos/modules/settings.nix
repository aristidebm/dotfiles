{pkgs, ...}:

{
  # Enable in-memory compressed devices and swap space provided by the zram
  # kernel module.
  zramSwap = {
    enable = true;
  };
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

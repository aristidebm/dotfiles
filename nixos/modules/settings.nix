{pkgs, ...}:

{

  zramSwap = {
    enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  # configuration source (https://github.com/NixOS/nixpkgs/blob/c27cdad491a991b11ed731760aa2ef8db0cb0410/nixos/modules/config/xdg/portals/wlr.nix)
  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = {
        chooser_type = "simple";
        chooser_cmd = "''${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -d";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

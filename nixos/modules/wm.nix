{ pkgs, lib, ...}:

{
  # # Enable the X11 windowing system.
  # services.xserver = {
  #   enable = true;
  #   autoRepeatDelay = 200;
  #   autoRepeatInterval = 35;
  #   windowManager.herbstluftwm.enable = true;
  #     displayManager.startx = {
  #       enable = true;
  #       # I will manage my own ~/.xinitrc
  #       generateScript = false;
  #     };
  # };

  programs.mango = {
    # Enabling automatically set add xdg portals and some goodies
    # for more information check https://github.com/mangowm/mango/blob/main/nix/nixos-modules.nix
    enable = true;
    # The default value of this option is true and it take effect only when
    # a display manager is configured, since I am not using display managers,
    # this option isn't really useful here, but yeah we will keep it
    addLoginEntry = false;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      quickshell
      ;
  };
}

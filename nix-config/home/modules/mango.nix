# mango is configured declaratively here (package + session integration) but
# its config files (~/.config/mango/{config.conf,autostart.sh}) are stowed.
# Leaving settings/extraConfig/autostart_sh empty makes the module only install
# the package and create the mango-session.target user unit.
{ ... }:

{
  wayland.windowManager.mango = {
    enable = true;
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
  };
}
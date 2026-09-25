# XDG desktop portal, fully home-manager managed so it works on NixOS and
# standalone Linux alike.
#
# All portal config live in nix now: only *utility* configurations (editors,
# shells, ...) remain stowed. mango-portals.conf is written by xdg.portal.config
# and the wlr screencast config by xdg.configFile. The UseIn=mango patch to
# xdg-desktop-portal-wlr comes from the mango-portal-fix overlay applied to
# home-manager's own pkgs.
{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];

    # ~/.config/xdg-desktop-portal/mango-portals.conf
    config.mango = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };

  # The portal frontend gates backend loading (wlr.portal's UseIn=...;mango;)
  # on XDG_CURRENT_DESKTOP. mangowm only imports it into the user systemd
  # manager *after* startup (autostart.sh), so the D-Bus-activated portal
  # service -- which starts earlier -- would never match it and expose no
  # org.freedesktop.portal.ScreenCast (screen sharing fails with "No such
  # interface ..."). Pinning it via environment.d makes it present in the
  # user manager environment from login.
  xdg.configFile."environment.d/10-mango.conf".text = ''
    XDG_CURRENT_DESKTOP=mango
  '';

  # ~/.config/xdg-desktop-portal-wlr/config
  xdg.configFile."xdg-desktop-portal-wlr/config".text = ''
    # vim:ft=ini
    [screencast]
    chooser_type = simple
    chooser_cmd = ${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -d
  '';

  # D-Bus session activation for the portal daemon and its backends:
  # dbus.packages links each package's share/dbus-1/services files under
  # ~/.local/share/dbus-1/services, so the session bus starts them on demand
  # without hand-written activation entries.
  dbus.packages = [
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
  ];
}

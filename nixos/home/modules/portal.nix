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
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

    # ~/.config/xdg-desktop-portal/mango-portals.conf
    config.mango = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };

  # ~/.config/xdg-desktop-portal-wlr/config
  xdg.configFile."xdg-desktop-portal-wlr/config".text = ''
    # vim:ft=ini
    [screencast]
    chooser_type = simple
    chooser_cmd = ${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -d
  '';

  # D-Bus session activation for the portal daemon and the wlr backend: the
  # session bus scans ~/.local/share/dbus-1/services, so pointing Exec at the
  # store paths starts them on demand on any system.
  xdg.dataFile = {
    "dbus-1/services/org.freedesktop.portal.Desktop.service" = {
      text = ''
        [D-BUS Service]
        Name=org.freedesktop.portal.Desktop
        Exec=${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal
      '';
    };
    "dbus-1/services/org.freedesktop.impl.portal.wlr.service" = {
      text = ''
        [D-BUS Service]
        Name=org.freedesktop.impl.portal.wlr
        Exec=${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr
      '';
    };
  };
}
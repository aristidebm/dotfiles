# XDG desktop portal, fully home-manager managed so it works on NixOS and
# standalone Linux alike.
#
# The per-portal config files (mango-portals.conf, xdg-desktop-portal-wlr/config)
# remain stowed; the UseIn=mango patch to xdg-desktop-portal-wlr comes from the
# mango-portal-fix overlay applied to home-manager's own pkgs.
{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

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
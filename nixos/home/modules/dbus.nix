# D-Bus session services. The vifm file-manager launcher script is stowed at
# ~/.local/bin/vifm-service.py; the python env provides its runtime.
{ pkgs, lib, ... }:

{
  # Runtime for the stowed vifm-service.py (shebang `#!/usr/bin/env python`,
  # imports dbus + gi). hiPrio so its bin/python (with dbus/gi) wins over the
  # bare python314 from modules/programming.nix in the merged profile.
  home.packages = [ (pkgs.hiPrio (pkgs.python3.withPackages (ps: [ ps.dbus-python ps.pygobject3 ]))) ];

  xdg.dataFile = {
    # Lets apps (e.g. editors' "open in file manager") talk to vifm via the
    # org.freedesktop.FileManager1 interface. The launcher script is stowed at
    # ~/.local/bin/vifm-service.py.
    "dbus-1/services/vifm.service" = {
      text = ''
        # vim:ft=ini
        [D-BUS Service]
        Name=org.freedesktop.FileManager1
        Exec=%h/.local/bin/vifm-service.py
      '';
    };

    # Does not launch anything: merely registers the name so quickshell's
    # NotificationServer becomes the preferred notification daemon.
    "dbus-1/services/org.freedesktop.Notifications.service" = {
      text = ''
        # vim:ft=ini
        [D-BUS Service]
        Name=org.freedesktop.Notifications
        Exec=/bin/true
      '';
    };
  };
}
# D-Bus session services. The vifm file-manager launcher script is stowed at
# ~/.local/bin/vifm-service.py; the python env provides its runtime.
{ pkgs, lib, config, ... }:

{
  # Runtime for the stowed vifm-service.py (shebang `#!/usr/bin/env python`, imports dbus + gi).
  home.packages = [ pkgs.python3.withPackages (ps: [ ps.dbus-python ps.pygobject3 ]) ];

  systemd.user.services.vifm-filemanager = {
    Unit = {
      Description = "vifm FileManager1 D-Bus service";
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.FileManager1";
      ExecStart = "${config.home.homeDirectory}/.local/bin/vifm-service.py";
    };
  };

  xdg.dataFile = {
    # Lets apps (e.g. editors' "open in file manager") talk to vifm via the
    # org.freedesktop.FileManager1 interface. The launcher script is stowed at
    # ~/.local/bin/vifm-service.py.
    # busctl --user status org.freedesktop.FileManager1
    "dbus-1/services/vifm.service" = {
      force = true;
      text = ''
        # vim:ft=ini
        [D-BUS Service]
        Name=org.freedesktop.FileManager1
        Exec=/usr/bin/false
        SystemdService=vifm-filemanager.service
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

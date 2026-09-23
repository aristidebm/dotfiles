{ pkgs, ... }:

{
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
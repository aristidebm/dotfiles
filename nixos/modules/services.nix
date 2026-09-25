{ pkgs
, lib
, ...
}:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Needed by the kanata user service (declared in home-manager),
  # which accesses /dev/uinput. Enabling the uinput hardware module
  # creates the uinput group and the udev rule giving it access
  # (KERNEL=="uinput", GROUP="uinput", MODE="0660").
  hardware.uinput.enable = true;
  users.users.aristide.extraGroups = [ "input" "uinput" ];

  # GPU/EGL driver stack (mesa + /run/opengl-driver) required by the
  # mangowm wayland compositor managed by home-manager. The mangowm NixOS
  # module used to enable these via services.graphical-desktop.enable.
  hardware.graphics.enable = true;
  programs.xwayland.enable = true;
  security.polkit.enable = true;

  # Real-time scheduling daemon for PipeWire; its org.freedesktop.RealtimeKit1
  # name is also probed by xdg-desktop-portal at startup.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
}

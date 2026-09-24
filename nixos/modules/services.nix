{
  pkgs,
  lib,
  ...
}:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Needed by the kanata user service (declared in home-manager),
  # which accesses /dev/uinput.
  users.users.aristide.extraGroups = [ "input" "uinput" ];

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
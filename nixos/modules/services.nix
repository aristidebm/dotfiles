{ pkgs, lib, ...}:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };
  # Declared in nioxs/modules/services/hardware/kanata.nix
  # Needed by kanata
  users.users.aristide.extraGroups = [ "input" "uinput" ];
  systemd.services.kanata-default.serviceConfig = {
    User = "aristide";
    # This line is important, without sudo nixos-rebuild switch cannot
    # start the service
    ProtectHome = lib.mkForce false;
  };
  services.kanata = {
      enable = true;
      keyboards = {
          default = {
              configFile = "$HOME/.config/kanata/keymaps.kbd";
          };
      };
  };

  services.emacs = {
    enable = true;
    # Replace with emacs-gtk, or a version provided by the community overlay if desired.
    package = pkgs.emacs;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  services.mpd = {
      enable = true;
  };
}

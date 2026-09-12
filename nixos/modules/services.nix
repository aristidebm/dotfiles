{ pkgs, lib, ...}:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Declared in nioxs/modules/services/hardware/kanata.nix
  # Needed by kanata
  users.users.aristide.extraGroups = [ "input" "uinput" ];
  services.kanata = {
      enable = true;
      keyboards = {
          default = {
              configFile = "../../kanata/.config/kanata/keymaps.kbd";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.mpd = {
      enable = true;
  };
}

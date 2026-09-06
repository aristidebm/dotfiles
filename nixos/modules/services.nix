{ lib, ...}:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Declared in nioxs/modules/services/hardware/kanata.nix
  services.kanata = {
      enable = true;
      keyboards = {
          default = {
              configFile = "/home/aristide/.config/kanata/keymaps.kbd";
          };
      };
  };

  systemd.services.kanata-default.serviceConfig = {
    User = "aristide";
    # This line is important, without sudo nixos-rebuild switch cannot
    # start the service
    ProtectHome = lib.mkForce false;
  };

  # Needed by kanata
  users.users.aristide.extraGroups = [ "input" "uinput" ];
}

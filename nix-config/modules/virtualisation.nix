{
  pkgs,
  lib,
  ...
 }:

{
  virtualisation = {
    docker.enable = lib.mkForce false;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [
          "--filter=until=24h"
          "--filter=lable!=important"
        ];
      };
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
       };
    };
  };

  users.users.aristide = {
    # Since I am the only on my system, systemd lingering isn't necessary
    # I want my containers to stop when I log out, pass to true if you want
    # the opposite
   # linger = false;
   extraGroups = [ "libvirtd" ];
  };
}

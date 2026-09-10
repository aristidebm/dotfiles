{
  pkgs,
  lib,
  ...
 }:

 let
  quadletDir = "containers/systemd/users/1000";
 in
{
  virtualisation = {
    docker.enable = lib.mkForce false;
    podman.enable = true;
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
   linger = false;
   extraGroups = [ "libvirtd" ];
  };

  environment.etc."${quadletDir}/valkey.container".source =
    ../../containers/systemd/valkey.container;

  environment.etc."${quadletDir}/workstation.network".source =
    ../../containers/systemd/workstation.network;

  environment.etc."${quadletDir}/postgres.container".source =
    ../../containers/systemd/postgres.container;

  environment.etc."${quadletDir}/postgres.volume".source =
    ../../containers/systemd/postgres.volume;
}

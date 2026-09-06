{pkgs, ...}:

{
  virtualisation = {
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
   extraGroups = [ "libvirtd" ];
  };
}

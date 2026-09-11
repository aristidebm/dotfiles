{pkgs, ...}:

{
  # Enable in-memory compressed devices and swap space provided by the zram
  # kernel module.
  zramSwap = {
    enable = true;
  };

  fileSystems."/home" = {
     device = "/dev/disk/by-uuid/4618906a-4003-49e2-9ab7-c3e96ae3d886";
     fsType = "ext4";
  };
}

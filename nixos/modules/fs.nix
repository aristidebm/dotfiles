{pkgs, ...}:

{
  # Enable in-memory compressed devices and swap space provided by the zram
  # kernel module.
  zramSwap = {
    enable = true;
  };
}

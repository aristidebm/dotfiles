{pkgs, ...}:

{
  # Use the systemd-boot EFI boot loader.
  boot.tmp.cleanOnBoot = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

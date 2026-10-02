{
  # https://nix-community.github.io/home-manager/usage/gpu-non-nixos.html
  # Non-NixOS systems: make Nix-installed GUI apps find the host's GL/Vulkan
  # driver stacks. On activation, home-manager prints a one-time command:
  #   sudo /nix/store/<hash>-non-nixos-gpu/bin/non-nixos-gpu-setup
  targets.genericLinux.enable = true;
}

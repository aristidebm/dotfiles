{pkgs, ...}:

{
    imports = [
      ./boot.nix
      ./fonts.nix
      ./locale.nix
      ./network.nix
      ./packages.nix
      ./programming.nix
      ./services.nix
      ./settings.nix
      ./users.nix
      ./virtualisation.nix
      ./wm.nix
    ];
}

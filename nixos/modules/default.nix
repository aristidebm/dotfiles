{pkgs, ...}:

{
    imports = [
      ./boot.nix
      ./fonts.nix
      ./locale.nix
      ./network.nix
      ./programs.nix
      ./services.nix
      ./settings.nix
      ./users.nix
      ./virtualisation.nix
      ./wm.nix
    ];
}

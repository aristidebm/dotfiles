{pkgs, ...}:

{
    imports = [
      ./media.nix
      ./boot.nix
      ./fonts.nix
      ./locales.nix
      ./mountpoints.nix
      ./network.nix
      ./packages.nix
      ./editors.nix
      ./processors.nix
      ./programming.nix
      ./services.nix
      ./settings.nix
      ./users.nix
      ./wm.nix
      ./virtualisation.nix
      ./disko.nix
    ];
}

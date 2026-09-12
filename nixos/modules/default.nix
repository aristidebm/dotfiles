{pkgs, ...}:

{
    imports = [
      ./media.nix
      ./boot.nix
      ./fonts.nix
      ./locales.nix
      ./fs.nix
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
    ];
}

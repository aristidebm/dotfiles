{
  description = "NixOS from scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
   disko,
   ...
  }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
         disko.nixosModules.disko
        ./configuration.nix
      ];
    };
    packages.${system}.default = pkgs.callPackage ./profiles/default.nix { };
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
  };
}

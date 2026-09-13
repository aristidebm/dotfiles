{
  description = "NixOS from scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    mangowm,
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
        ./configuration.nix
        mangowm.nixosModules.mango
      ];
    };
    packages.${system}.default = pkgs.callPackage ./profiles/default.nix { };
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
  };
}

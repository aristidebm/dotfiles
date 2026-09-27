{
  description = "NixOS from scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    voxtype = {
      url = "github:peteonrails/voxtype?ref=v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    mangowm,
    voxtype,
    ...
  }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Portable, standalone home-manager configuration for non-NixOS systems.
    # Shares ./home with the NixOS module below.
    homeConfigurations."aristide@x86_64-linux" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit voxtype;
      };
      modules = [
        mangowm.hmModules.mango
        voxtype.homeManagerModules.default
        ./home
        ./home/standalone.nix
      ];
    };

    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            # Build home-manager's own pkgs so overlays declared in
            # home/modules/nixpkgs.nix are honored.
            useGlobalPkgs = false;
            # Keep the user environment under ~/.nix-profile, which the
            # stowed scripts (vifm-service.py, ...) already reference.
            useUserPackages = true;
            extraSpecialArgs = {
              inherit voxtype;
            };
            sharedModules = [
              mangowm.hmModules.mango
              voxtype.homeManagerModules.default
            ];
            users.aristide = import ./home;
          };
        }
      ];
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
  };
}

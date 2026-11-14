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
  };

  outputs = {
    nixpkgs,
    home-manager,
    mangowm,
    ...
  }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    homeModules = {
      default = ./home;
      mango = mangowm.hmModules.mango;
      standalone = {
        imports = [
          ./home
          ./home/standalone.nix
        ];
      };
    };
  in
  {
    inherit homeModules;

    nixosModules.default = ./configuration.nix;

    # Portable, standalone home-manager configuration for non-NixOS systems.
    # Shares ./home with the NixOS module below.
    homeConfigurations."aristide@x86_64-linux" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
      };
      modules = [
        homeModules.mango
        homeModules.standalone
      ];
    };

    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./hosts/workstation.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            # Build home-manager's own pkgs so overlays declared in
            # home/modules/nixpkgs.nix are honored.
            useGlobalPkgs = false;
            # Keep the user environment under ~/.nix-profile, which the
            # stowed scripts (vifm-service.py, ...) already reference.
            useUserPackages = true;
            sharedModules = [
              homeModules.mango
            ];
            backupFileExtension = "backup";
            # backupCommand = "";
            users.aristide = homeModules.default;
          };
        }
      ];
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
  };
}

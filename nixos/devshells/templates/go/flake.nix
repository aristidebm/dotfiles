{
  description = "Go Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          go = pkgs.go_1_26; # ← change toolchain version here
        in {
          default = pkgs.mkShell {
            packages = [go] ++ (with pkgs; [
              gopls
              gotools
              gnumake
            ]);
            env = {
              GOPATH = "${builtins.getEnv "HOME"}/go";
              GOROOT = "${go}/share/go";
            };
          };
        }
      );

      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
    };
}

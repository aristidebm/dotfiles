{
  description = "Python Development Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/?ref=nixos-unstable";
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
    in
    {
      devShells = forAllSystems (system:
        let
          # legacyPackages is an instance of nixpkgs, check here why it is
          # needed https://discourse.nixos.org/t/using-nixpkgs-legacypackages-system-vs-import/17462/8
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              (python3.withPackages(ps: with ps; [
                  ipython
                  ipdb
              ]))
              uv
              pyrefly
              sqlite-interactive
              gnumake
            ];
            env = {
              PYTHONBREAKPOINT = "ipdb.set_trace";
              # https://docs.astral.sh/uv/reference/environment/#uv_log_context
              UV_PROJECT_ENVIRONMENT = "venv";
              # .env files from which to load environment variables when executing uv run commands.
              UV_ENV_FILE = ".envrc";
              # When enabled, uv performs a lightweight check against the OSV database for known
              # malware advisories after every lockfile sync. Set this variable to 0 to opt out.
              UV_MALWARE_CHECK = 1;
            };
            shellHook = ''
              test ! -f .gitignore && yes | git ignore python
              test ! -d venv && python -m venv venv --system-site-packages
              test ! -f pyproject.toml && uv init --bare --quiet
              source venv/bin/activate && uv sync --active --quiet
            '';
          };
        }
      );
      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
    };
}

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
              poetry
              pyrefly
              sqlite-interactive
              gnumake
            ];
            env = {
              PYTHONBREAKPOINT = "ipdb.set_trace";
              # Use the .venv file inside the project
              POETRY_VIRTUALENVS_IN_PROJECT = true;
              # Use the activated Python version to create a new virtual environment instead
              # of the one used to install poetry
              POETRY_VIRTUALENVS_USE_POETRY_PYTHON = false;
              # Include system packages into virtualenv (useful for python311.withPackages
              # to be visible)
              POETRY_VIRTUALENVS_OPTIONS_SYSTEM_SITE_PACKAGES = true;
            };
            shellHook = ''
              test ! -f .gitignore && yes | git ignore python
              test ! -d venv && python -m venv venv
              test ! -f pyproject.toml && poetry init --no-interaction
              source venv/bin/activate && poetry install
            '';
          };
        }
      );
      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
    };
}

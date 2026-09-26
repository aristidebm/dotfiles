# Podman user containers via home-manager's native services.podman quadlet
# support: user-level containers that start with the session (linger keeps
# them alive). The .container/.network/.volume units are generated from here
# and written to ~/.config/containers/systemd/ by home-manager.
{ pkgs, lib, ... }:

{
  xdg.configFile."containers/registries.conf".source = lib.mkForce (
    pkgs.writeText "registries.conf" ''
      unqualified-search-registries = ["docker.io"]

      # I have an issue downloading image via cloudfront (docker.io)
      # I have to use google mirror to be able to download them
      [[registry]]
      location = "docker.io"

      [[registry.mirror]]
      location = "mirror.gcr.io"
    ''
  );

  # https://raw.githubusercontent.com/nix-community/home-manager/7b4c5ec4bedaf1e062bbc1bcaeddbc6bd242aa1b/modules/services/podman/default.nix

  services.podman = {
    enable = true;

    networks.workstation = {
      description = "Workstation bridge network shared by local containers";
      driver = "bridge";
    };

    volumes.postgres = { };

    containers.valkey = {
      description = "Valkey (Redis-compatible cache)";
      image = "docker.io/valkey/valkey:8.0.1-alpine";
      network = "workstation.network";
      ports = [ "127.0.0.1:6379:6379" ];
    };

    containers.postgres = {
      description = "PostgreSQL database";
      image = "docker.io/pgvector/pgvector:pg17-trixie";
      network = "workstation.network";
      volumes = [ "postgres.volume:/var/lib/postgresql/data" ];
      environment = {
        POSTGRES_USER = "appuser";
        POSTGRES_DB = "appdb";
      };
      # POSTGRES_PASSWORD lives in ~/.config/containers/secrets/postgres.env.
      environmentFile = [ "%h/.config/containers/secrets/postgres.env" ];
      ports = [ "127.0.0.1:5432:5432" ];
      extraConfig.Unit.After = [ "podman-valkey.service" ];
    };
  };
}

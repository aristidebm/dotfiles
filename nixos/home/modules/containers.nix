# Podman user containers via home-manager's native services.podman quadlet
# support: user-level containers that start with the session (linger keeps
# them alive). The .container/.network/.volume units are generated from here
# and written to ~/.config/containers/systemd/ by home-manager.
{ ... }:

{
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
      image = "docker.io/library/postgres:17-alpine";
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
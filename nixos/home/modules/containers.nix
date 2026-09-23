# Podman user quadlets: user-level containers that start with the session
# (linger keeps them alive). The .container/.network files are service
# descriptors, so managing them from home-manager is fine.
{ pkgs, ... }:

{
  xdg.dataFile = {
    "containers/systemd/valkey.container".source =
      ../../../containers/systemd/valkey.container;
    "containers/systemd/postgres.container".source =
      ../../../containers/systemd/postgres.container;
    "containers/systemd/postgres.volume".source =
      ../../../containers/systemd/postgres.volume;
    "containers/systemd/workstation.network".source =
      ../../../containers/systemd/workstation.network;
  };
}
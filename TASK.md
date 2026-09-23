# Home-manager migration

Rebuild the NixOS configuration around home-manager so that home-manager
becomes the source of truth and the whole user environment is portable to
non-NixOS systems.

## Goals

- home-manager is the source of truth for:
  - user packages (`home.packages`)
  - `systemd --user` services (mpd, mpd-mpris, emacs, kanata, portal)
  - D-Bus session services (vifm file-manager, quickshell notifications)
  - Podman user quadlet containers (valkey, postgres)
  - Mango (via the mangowm home-manager module)
  - xdg-desktop-portal setup + the `UseIn=mango` overlay
  - specialisation plumbing
- NixOS keeps the least config possible: hardware, boot, network, users,
  fonts, pipewire, podman daemon, libvirtd, zram, nix gc/settings, nix-ld.
- home-manager MUST NOT manage user dotfiles. Stow keeps owning
  `~/.config/*` and friends. Exception: *service descriptors* (quadlet
  files and `dbus-1/services`), which the user explicitly wants in
  home-manager.
- `nixos/profiles/` is deleted — it existed for non-NixOS installs, which
  the standalone `homeConfigurations` output now covers.
- on NixOS, home-manager is imported as a NixOS module; on other systems,
  the same `nixos/home/` module is driven by `homeConfigurations`.

## Architecture

```
nixos/
  flake.nix           # inputs += home-manager; shares ./home between outputs
  configuration.nix   # minimal: imports + home-manager wiring
  modules/            # system-only modules (packages/services/wm/overlays removed)
  home/               # ★ portable source of truth, shared by both outputs ★
    default.nix
    overlays/mango-portal-fix.nix
    packages/custom/*.nix          # habits, dbcli, typer, pomodoro, apic
    modules/
      nixpkgs.nix                  # allowUnfree + overlays for HM's own pkgs
      packages.nix                 # full merged home.packages
      services.nix                 # systemd.user.services
      dbus.nix                     # dbus-1/services (vifm, quickshell)
      containers.nix               # user quadlets
      mango.nix                    # wayland.windowManager.mango (no settings)
      portal.nix                   # xdg.portal + wlr portal as user/dbus service
      specialisation.nix           # plumbing only
  homeConfigurations."aristide@x86_64-linux"
  nixosConfigurations.workstation
```

## Design notes

- Mango HM module only writes `config.conf`/`autostart.sh` when
  `settings`/`extraConfig`/`autostart_sh` are non-empty. With all empty and
  `enable = true` it just installs the package + creates `mango-session.target`
  — so the stowed `mango/.config/mango/*` stay authoritative.
- `home-manager.useUserPackages = true` keeps path `~/.nix-profile`
  (existing scripts already reference it). `useGlobalPkgs = false` so the
  overlay in `home/modules/nixpkgs.nix` is applied to HM's own pkgs.
- Standalone `homeConfigurations` passes `pkgs = nixpkgs.legacyPackages.${system}`;
  HM merges the module-level `nixpkgs.overlays`/`nixpkgs.config` (list merge
  for overlays, `mkDefault` for config) on both backends.
- NixOS must add `environment.pathsToLink = ["/share/xdg-desktop-portal"
  "/share/applications"]` (required by HM's `xdg.portal` assertion when
  `useUserPackages` is enabled).

## Migration steps (one commit each)

1. TASK.md (this file)
2. flake + `home/` skeleton + both outputs wired
3. packages into `home.packages`; delete `nixos/profiles/`
4. systemd user services + mango; drop `services.{emacs,mpd,kanata}`,
   `programs.mango`, stowed `systemd/.config/systemd/user/*`
5. dbus services + user quadlets
6. portal + overlay into home-manager
7. specialisation wiring + NixOS slimming

## Post-migration manual steps on the machine

- `home-manager` user units replace the stowed ones: remove the stale symlinks
  left by the deleted `systemd/.config/systemd/user/*` files
  (e.g. `stow --delete systemd` or `rm ~/.config/systemd/user/{kanata,mpd,mpd-mpris}.service`).
- `nixos-rebuild switch` then `systemctl --user daemon-reload` and start units.
- Verify quadlets: `systemctl --user list-units '*.service' | rg 'valkey|postgres'`.
- Verify dbus: `busctl --user status org.freedesktop.FileManager1`.
- Verify portal/screencast: `busctl --user status org.freedesktop.portal.Desktop`
  and a `wf-recorder` test.
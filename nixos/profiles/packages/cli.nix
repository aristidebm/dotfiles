{ pkgs }:
let
  habits = pkgs.callPackage ./custom/habits.nix { };
  dbcli = pkgs.callPackage ./custom/dbcli.nix { };
  typer = pkgs.callPackage ./custom/typer.nix { };
  pomodoro = pkgs.callPackage ./custom/pomodoro.nix { };
  apic = pkgs.callPackage ./custom/apic.nix { };
  zathura-full = pkgs.callPackage ./custom/zathura-full.nix { };
in

with pkgs; [
  git
  gh
  glab
  jujutsu
  curl
  bat
  vifm
  fd
  lsd
  zoxide
  tmux
  sesh
  starship
  btop
  direnv
  nix-direnv
  just
  stow
  steel
  steelix
  atuin
  ttyper
  tokei
  ncdu
  inxi
  gopass
  fastfetch
  zrok
  kanata
  cloudflared
  glow
  brotli
  tabiew
  figlet
  habits
  dbcli
  typer
  pomodoro
  apic
  zathura-full
]

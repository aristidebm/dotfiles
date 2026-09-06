{pkgs, ...}:

let
  habits = pkgs.callPackage ../profiles/packages/custom/habits.nix { };
  dbcli = pkgs.callPackage ../profiles/packages/custom/dbcli.nix { };
  typer = pkgs.callPackage ../profiles/packages/custom/typer.nix { };
  pomodoro = pkgs.callPackage ../profiles/packages/custom/pomodoro.nix { };
  apic = pkgs.callPackage ../profiles/packages/custom/apic.nix { };
in

{
    programs.firefox.enable = true;
    programs.bash.enable = true;
    programs.zsh.enable = true;
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib   # libstdc++ etc — usually the one treesitter needs
        zlib
        glibc
      ];
    };
    users.users.aristide.packages = with pkgs; [
      tree
      fd
      lsd
      direnv
      nix-direnv
      atuin
      sqlite-interactive
      pgcli
      stow
      starship
      ttyper
      figlet
      fastfetch
      tokei
      ncdu
      habits
      dbcli
      typer
      pomodoro
      apic
      jujutsu
      cloudflared
      glow
      gum
    ];
    environment.systemPackages = with pkgs; [
      git
      wezterm
      tmux
      zoxide
      sesh
      vifm
      btop
      tor-browser
      inxi
      wl-copy
      unzip
      ncdu
      gopass
      brotli
   ];
}

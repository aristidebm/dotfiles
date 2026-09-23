{ pkgs, ... }:

let
  habits = pkgs.callPackage ./custom/habits.nix { };
  dbcli = pkgs.callPackage ./custom/dbcli.nix { };
  typer = pkgs.callPackage ./custom/typer.nix { };
  pomodoro = pkgs.callPackage ./custom/pomodoro.nix { };
  apic = pkgs.callPackage ./custom/apic.nix { };

  mpv = pkgs.mpv.override {
    scripts = builtins.attrValues {
      inherit (pkgs.mpvScripts)
        mpris
        autoload
        mpv-cheatsheet-ng
        memo
        reload
        uosc
        thumbfast
        sponsorblock
      ;
    };
  };

  zathura-full = pkgs.zathura.override {
    plugins = builtins.attrValues {
      inherit (pkgs.zathuraPkgs)
        zathura_pdf_mupdf
      ;
    };
  };
in
{
  home.packages = [
    # CLI toolkit
    pkgs.atuin
    pkgs.aria2
    pkgs.bat
    pkgs.brotli
    pkgs.btop
    pkgs.cloudflared
    pkgs.curl
    pkgs.dasel
    pkgs.direnv
    pkgs.fd
    pkgs.figlet
    pkgs.fx
    pkgs.fzf
    pkgs.gawk
    pkgs.git
    pkgs.glow
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gopass
    pkgs.gron
    pkgs.gum
    pkgs.inxi
    pkgs.jq
    pkgs.jujutsu
    pkgs.just
    pkgs.lsd
    pkgs.ncdu
    pkgs.nix-direnv
    pkgs.pandoc
    pkgs.pastel
    pkgs.qpdf
    pkgs.remind
    pkgs.ripgrep
    pkgs.rsync
    pkgs.starship
    pkgs.steelix
    pkgs.stow
    pkgs.tabiew
    pkgs.tmux
    pkgs.tokei
    pkgs.tree
    pkgs.unzip
    pkgs.vifm
    pkgs.wget
    pkgs.zip
    pkgs.zoxide
    pkgs.zrok

    # terminals / editors
    pkgs.alacritty
    pkgs.emacs
    pkgs.neovim
    pkgs.vim
    pkgs.zed-editor

    # system / productivity
    pkgs.fastfetch
    pkgs.keepassxc
    pkgs.obs-studio
    pkgs.onlyoffice-desktopeditors
    pkgs.sesh
    pkgs.telegram-desktop
    pkgs.tor-browser
    pkgs.ttyper

    # databases
    pkgs.pgcli
    pkgs.sqlite-interactive

    # media / screen
    pkgs.brightnessctl
    pkgs.ffmpeg-full
    pkgs.grim
    pkgs.libnotify
    pkgs.mpc
    pkgs.mpd
    pkgs.mpd-mpris
    pkgs.nsxiv
    pkgs.playerctl
    pkgs.quickshell
    pkgs.satty
    pkgs.slurp
    pkgs.wf-recorder
    pkgs.wireshark-cli
    pkgs.wl-clipboard
    pkgs.yt-dlp

    # keyboard remapping
    pkgs.kanata

    # custom tools (packaged from aristidebm repos)
    apic
    dbcli
    habits
    pomodoro
    typer

    # overridden builds
    mpv
    zathura-full
  ];
}
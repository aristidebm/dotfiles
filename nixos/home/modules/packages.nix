{ pkgs, ... }:

let
  habits = pkgs.callPackage ../packages/custom/habits.nix { };
  dbcli = pkgs.callPackage ../packages/custom/dbcli.nix { };
  typer = pkgs.callPackage ../packages/custom/typer.nix { };
  pomodoro = pkgs.callPackage ../packages/custom/pomodoro.nix { };
  apic = pkgs.callPackage ../packages/custom/apic.nix { };

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

  # Needed by the stowed vifm dbus service (vifm-service.py).
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.dbus-python ps.pygobject3 ]);
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

    # programming toolchains / LSP
    pkgs.ast-grep
    pkgs.cargo
    pkgs.clippy
    pkgs.emmylua-ls
    pkgs.fabric-ai
    pkgs.gcc
    pkgs.gh
    pkgs.glab
    pkgs.gnumake
    pkgs.go
    pkgs.go_1_27
    pkgs.gopls
    pkgs.harper
    pkgs.kulala-fmt
    pkgs.nil
    pkgs.nodejs
    pkgs.opencode
    pkgs.pyrefly
    pkgs.python314
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.rustfmt
    pkgs.rustup
    pkgs.sleek
    pkgs.silicon
    pkgs.tinymist
    pkgs.typescript-language-server
    pkgs.typst
    pkgs.uv

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

    # python env for the vifm dbus service
    pythonEnv
  ];
}
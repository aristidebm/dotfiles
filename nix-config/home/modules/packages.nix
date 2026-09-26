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
  home.packages = builtins.attrValues ({
    inherit (pkgs)
      # CLI toolkit
      atuin
      aria2
      bat
      brotli
      btop
      cloudflared
      curl
      dasel
      direnv
      fd
      figlet
      fx
      fzf
      gawk
      git
      glow
      gnugrep
      gnused
      gopass
      gron
      gum
      inxi
      jq
      jujutsu
      just
      lsd
      ncdu
      nix-direnv
      pandoc
      pastel
      qpdf
      remind
      ripgrep
      rsync
      starship
      steelix
      stow
      tabiew
      tmux
      tokei
      tree
      unzip
      vifm
      wget
      zip
      zoxide
      zrok

      # terminals / editors
      alacritty
      emacs
      neovim
      vim
      zed-editor

      # system / productivity
      fastfetch
      keepassxc
      obs-studio
      onlyoffice-desktopeditors
      sesh
      telegram-desktop
      tor-browser
      ttyper

      # databases
      pgcli
      sqlite-interactive

      # media / screen
      brightnessctl
      ffmpeg-full
      grim
      libnotify
      mpc
      mpd
      mpd-mpris
      nsxiv
      playerctl
      quickshell
      satty
      slurp
      wf-recorder
      wireshark-cli
      wl-clipboard
      yt-dlp

      # keyboard remapping
      kanata
    ;
  } // {
    inherit
      # custom tools (packaged from aristidebm repos)
      apic
      dbcli
      habits
      pomodoro
      typer

      # overridden builds
      mpv
      zathura-full
    ;
  });
}

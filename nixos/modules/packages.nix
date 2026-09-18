{pkgs, ...}:

let
  habits = pkgs.callPackage ../profiles/packages/custom/habits.nix { };
  dbcli = pkgs.callPackage ../profiles/packages/custom/dbcli.nix { };
  typer = pkgs.callPackage ../profiles/packages/custom/typer.nix { };
  pomodoro = pkgs.callPackage ../profiles/packages/custom/pomodoro.nix { };
  apic = pkgs.callPackage ../profiles/packages/custom/apic.nix { };
  zathura-full = pkgs.callPackage ../profiles/packages/custom/zathura-full.nix { };
  mpv = pkgs.callPackage ../profiles/packages/custom/mpv.nix { };
in

{
    programs.firefox.enable = true;
    programs.bash.enable = true;
    programs.zsh.enable = true;
    # programs.appimage.enable = true;
    # programs.appimage.binfmt = true;
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib   # libstdc++ etc — usually the one treesitter needs
        zlib
        glibc
      ];
    };

    users.users.aristide.packages = builtins.attrValues ({
      inherit (pkgs)
        atuin
        bat
        cloudflared
        dasel
        direnv
        emacs
        fastfetch
        fd
        figlet
        glow
        gum
        jujutsu
        keepassxc
        lsd
        ncdu
        neovim
        nix-direnv
        obs-studio
        onlyoffice-desktopeditors
        pandoc
        pastel
        pgcli
        qpdf
        remind
        ripgrep
        sqlite-interactive
        starship
        steelix
        stow
        tabiew
        telegram-desktop
        tokei
        tor-browser
        tree
        ttyper
        yt-dlp
        zed-editor
      ;
    } // {
      inherit
        apic
        dbcli
        habits
        pomodoro
        typer
      ;
  });

    environment.systemPackages = builtins.attrValues ({
      inherit (pkgs)
        alacritty
        aria2
        brightnessctl
        brotli
        btop
        curl
        ffmpeg-full
        fx
        fzf
        gawk
        git
        gnugrep
        gnused
        gopass
        grim
        inxi
        jq
        kanata
        libnotify
        mpc
        mpd
        mpd-mpris
        ncdu
        nsxiv
        playerctl
        quickshell
        rsync
        satty
        sesh
        slurp
        tmux
        unzip
        vifm
        vim
        wf-recorder
        wget
        wireshark-cli
        wl-clipboard
        zoxide
        zrok
      ;
    } // {
    inherit
      mpv
      zathura-full
      ;
  });
}

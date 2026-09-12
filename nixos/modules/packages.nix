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
        ast-grep
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
        lsd
        ncdu
        neovim
        nix-direnv
        pandoc
        pastel
        pgcli
        qpdf
        ripgrep
        sqlite-interactive
        starship
        steelix
        stow
        tabiew
        tokei
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
        libnotify
        mpc
        mpd
        mpd-mpris
        ncdu
        nsxiv
        playerctl
        quickshell
        remind
        rsync
        satty
        sesh
        slurp
        tmux
        tor-browser
        unzip
        vifm
        vim
        wezterm
        wget
        wireshark-cli
        wl-copy
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

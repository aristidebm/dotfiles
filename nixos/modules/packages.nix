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
        neovim
        steelix
        zed-editor
        emacs
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
        jujutsu
        cloudflared
        glow
        gum
        ast-grep
        ripgrep
        dasel
        pandoc
        tabiew
        bat
        qpdf
        yt-dlp
        pastel
      ;
    } // {
      inherit
        habits
        dbcli
        typer
        pomodoro
        apic
      ;
  });

    environment.systemPackages = builtins.attrValues ({
      inherit (pkgs)
        aria2
        brightnessctl
        brotli
        btop
        curl
        ffmpeg
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
        quickshell
      ;
    } // {
    inherit
      mpv
      zathura-full
      ;
  });
}

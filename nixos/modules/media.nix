{pkgs, ...}:

let
  zathura-full = pkgs.callPackage ../profiles/packages/custom/zathura-full.nix { };
  mpv = pkgs.callPackage ../profiles/packages/custom/mpv.nix { };
in
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  services.mpd = {
      enable = true;
  };

  users.users.aristide.packages = builtins.attrValues {
    inherit (pkgs)
      pastel
      ;
  };

  environment.systemPackages = builtins.attrValues ({
    inherit (pkgs)
       ffmpeg
       nsxiv
       mpc
       mpd
       mpd-mpris
       playerctl
       brightnessctl
       yt-dlp
       satty
       grim
       slurp
       libnotify
    ;
  } // {
    inherit
      mpv
      zathura-full
      ;
  });
}

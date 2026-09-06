{pkgs, ...}:

let
  zathura-full = pkgs.callPackage ../profiles/packages/custom/zathura-full.nix { };
  mpv = pkgs.callPackage ../profiles/packages/custom/mpv.nix { };
in
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.mpd = {
      enable = true;
  };

  users.users.aristide.packages = with pkgs; [
      pastel
  ];

  environment.systemPackages = (with pkgs; [
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
  ]) ++ [
    mpv
    zathura-full
  ];
}

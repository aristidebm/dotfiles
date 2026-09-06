{ pkgs }:
let
  mpv = pkgs.callPackage ./custom/mpv.nix { };
in
with pkgs; [
  mpv
  mpd
  mpd-mpris
  mpc
  ffmpeg-full
  playerctl
  nsxiv
  wf-recorder
  silicon
  libnotify
  yt-dlp
  grim
  gum
  slurp
  brightnessctl
  quickshell
  pastel
]

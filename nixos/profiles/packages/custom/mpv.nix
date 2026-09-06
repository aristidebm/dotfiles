{ pkgs }:

pkgs.mpv.override {
  scripts = with pkgs.mpvScripts; [
    mpris
    autoload
    mpv-cheatsheet-ng
    memo
    reload
    uosc
    thumbfast
    sponsorblock
  ];
}

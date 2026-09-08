{ pkgs }:

pkgs.mpv.override {
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
}

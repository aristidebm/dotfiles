{ pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glibc
    ];
  };
}
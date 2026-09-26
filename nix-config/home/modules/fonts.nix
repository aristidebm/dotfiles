{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = builtins.attrValues {
    inherit (pkgs.nerd-fonts)
      jetbrains-mono
      iosevka
      fira-code
    ;
  };
}

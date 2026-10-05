{ pkgs, ... }:

{
  home.packages = builtins.attrValues ({
    inherit (pkgs.nerd-fonts)
      jetbrains-mono
      iosevka
    ;
  } // {
    inherit (pkgs)
      noto-fonts-color-emoji
      noto-fonts
      noto-fonts-cjk-sans
    ;
  });

  # For more information about fontconfig, check this
  # https://wiki.archlinux.org/title/Font_configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Iosevka Nerd Font" "JetBrainsMono Nerd Font" "DejaVu Sans Mono" "Noto Sans CJK SC" ];
      sansSerif = [ "DejaVu Sans" "Noto Sans CJK SC" ];
      serif     = [ "DejaVu Serif" "Noto Serif CJK SC" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };
}

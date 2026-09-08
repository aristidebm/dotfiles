{pkgs, ...}:

let
  inherit (pkgs) nerd-fonts;
in
{
   fonts.packages = builtins.attrValues {
     inherit(nerd-fonts)
        jetbrains-mono
        iosevka
     ;
    };
}

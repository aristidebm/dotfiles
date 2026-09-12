{pkgs, ...}:

{
   fonts.packages = builtins.attrValues {
     inherit(pkgs.nerd-fonts)
        jetbrains-mono
        iosevka
        fira-code
     ;
    };
}

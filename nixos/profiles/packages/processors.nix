{pkgs}:

builtins.attrValues {
  inherit (pkgs)
    gawk
    jq
    gron
    fx
    ripgrep
    ast-grep
    dasel
    fzf
    pandoc
    qpdf
  ;
}

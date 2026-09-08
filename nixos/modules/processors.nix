{pkgs, ...}:

{
  users.users.aristide.packages = builtins.attrValues {
    inherit (pkgs)
     ast-grep
     ripgrep
     dasel
     pandoc
     tabiew
     bat
     qpdf
    ;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
       gnugrep
       fzf
       fx
       jq
    ;
  };
}

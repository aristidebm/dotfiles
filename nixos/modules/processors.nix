{pkgs, ...}:

{
  users.users.aristide.packages = with pkgs; [
     ast-grep
     ripgrep
     dasel
     pandoc
     tabiew
     bat
     qpdf
  ];

  environment.systemPackages = with pkgs; [
     gnugrep
     fzf
     fx
     jq
  ];
}

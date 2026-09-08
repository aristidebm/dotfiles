{pkgs, ...}:

{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      vim
      gnused
      gawk
    ;
  };

  users.users.aristide.packages = builtins.attrValues {
    inherit (pkgs)
      neovim
      steelix
      zed-editor
      emacs
    ;
  };

  services.emacs = {
    enable = true;
    # Replace with emacs-gtk, or a version provided by the community overlay if desired.
    package = pkgs.emacs;
  };
}

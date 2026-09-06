{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    vim
    gnused
    gawk
  ];

  users.users.aristide.packages = with pkgs; [
    neovim
    steelix
    zed-editor
    emacs
  ];

  services.emacs = {
    enable = true;
    # Replace with emacs-gtk, or a version provided by the community overlay if desired.
    package = pkgs.emacs;
  };
}

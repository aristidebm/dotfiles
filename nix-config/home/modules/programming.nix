{
  config,
  lib,
  pkgs,
  ...
}:

# Programming toolchains / language servers. Kept separate from the general
# package list so the programming environment stays a clearly identifiable,
# self-contained unit.
{
  # https://raw.githubusercontent.com/nix-community/home-manager/refs/heads/master/modules/programs/pi-coding-agent.nix
  programs.pi-coding-agent = {
    enable = true;

    extraPackages = builtins.attrValues {
      inherit (pkgs)
        nodejs
        bun
        git
      ;
    };

    configDir = "${config.xdg.configHome}/pi/agent";

    settings = {
       # https://pi.dev/docs/latest/settings
       packages = [
        "npm:@termdraw/pi"
        "npm:pi-mcp-adapter"
        "npm:pi-lens"
        "npm:pi-web-access"
        "npm:@juicesharp/rpiv-ask-user-question"
        "npm:@juicesharp/rpiv-todo"
        "npm:@plannotator/pi-extension"
        "npm:@maplezzk/pi-interactive-subagents"
        "npm:pi-token-tracker"
      ];
    };
  };

  home.packages = builtins.attrValues {
     inherit(pkgs)
       # programming toolchains / LSP
       ast-grep
       cargo
       clippy
       emmylua-ls
       gcc
       gh
       glab
       gnumake
       go
       gopls
       harper
       kulala-fmt
       nil
       nodejs
       opencode
       pyrefly
       rust-analyzer
       rustc
       rustfmt
       sleek
       silicon
       tinymist
       typescript-language-server
       typst
       uv
     ;
    };
}

{ pkgs, ... }:

# Programming toolchains / language servers. Kept separate from the general
# package list so the programming environment stays a clearly identifiable,
# self-contained unit.
{
  home.packages = [
    # programming toolchains / LSP
    pkgs.ast-grep
    pkgs.cargo
    pkgs.clippy
    pkgs.emmylua-ls
    pkgs.fabric-ai
    pkgs.gcc
    pkgs.gh
    pkgs.glab
    pkgs.gnumake
    pkgs.go
    pkgs.gopls
    pkgs.harper
    pkgs.kulala-fmt
    pkgs.nil
    pkgs.nodejs
    pkgs.opencode
    pkgs.pyrefly
    pkgs.python314
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.rustfmt
    pkgs.sleek
    pkgs.silicon
    pkgs.tinymist
    pkgs.typescript-language-server
    pkgs.typst
    pkgs.uv
  ];
}
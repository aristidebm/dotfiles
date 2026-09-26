{ pkgs, ... }:

# Programming toolchains / language servers. Kept separate from the general
# package list so the programming environment stays a clearly identifiable,
# self-contained unit.
{
  home.packages = builtins.attrValues {
     inherit(pkgs)
       # programming toolchains / LSP
       ast-grep
       cargo
       clippy
       emmylua-ls
       fabric-ai
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

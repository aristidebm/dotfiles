{pkgs, ...}:

{
  users.users.aristide.packages = builtins.attrValues {
    inherit (pkgs)
       gh
       glab
       nodejs
       gcc
       uv
       go
       typst
       rustc
       cargo
       rustfmt
       clippy
       sleek
       harper
       nil
       emmylua-ls
       tinymist
       gopls
       pyrefly
       typescript-language-server
       rust-analyzer
       python314
       gnumake
    ;
  };
}

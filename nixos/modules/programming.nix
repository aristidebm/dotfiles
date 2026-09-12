{pkgs, ...}:

{
  users.users.aristide.packages = builtins.attrValues {
    inherit (pkgs)
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
       nil
       nodejs
       pyrefly
       python314
       rust-analyzer
       rustc
       rustfmt
       sleek
       tinymist
       typescript-language-server
       typst
       uv
    ;
  };
}

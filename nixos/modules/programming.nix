{pkgs, ...}:

{
  users.users.aristide.packages = builtins.attrValues {
    inherit (pkgs)
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

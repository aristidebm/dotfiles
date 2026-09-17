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
       opencode
       pyrefly
       python314
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

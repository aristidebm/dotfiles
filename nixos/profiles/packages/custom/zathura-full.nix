{ pkgs }:

pkgs.zathura.override {
  plugins = builtins.attrValues {
    inherit (pkgs.zathuraPkgs)
      zathura_pdf_mupdf
    ;
  };
}

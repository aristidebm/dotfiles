{ pkgs }:

pkgs.zathura.override {
  plugins = with pkgs.zathuraPkgs; [ zathura_pdf_mupdf ];
}

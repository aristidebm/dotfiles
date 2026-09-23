{
  lib,
   buildGoModule,
   fetchFromGitHub,
}:

buildGoModule {
  pname = "typer";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "aristidebm";
    repo = "typer";
    rev = "649bcd4d2966cb161ca29202fee073660d97d7a4";
    hash = "sha256-A/j1H3TYJ6g5qG2HD0VeyIAD/rymZRyJ0BH/6cNvfxw=";
  };
  vendorHash = "sha256-zgQKClAmZcy9N88UEOcOig34Z9e2vQro30hPiMeIs4s=";
  meta = {
    description = "A Key Log application to help increase my touch typing accuracy and speed";
    mainProgram  = "typer";
    homepage = "https://github:aristidebm/typer";
    license = lib.licenses.mit;
  };
  postInstall = ''
     mv $out/bin/cmd $out/bin/typer
  '';
}

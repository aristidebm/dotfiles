{
  lib,
  pkg-config,
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "pomodoro";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "aristidebm";
    repo = "pomodoro";
    rev = "192b25f46f0bcffaa4287e96ce9382073b2561be";
    hash = "sha256-nkFarvVE3Aay1OBUVZyaJFG10p4KiuNyvSfcOuQ8PcQ=";
  };
  vendorHash = "sha256-2g+gZnaflExgInWDSV1yXyqhCqSMQtLH7xDEOc8sWZA=";
  meta = {
    description = "A pomodoro timer that help me keep focus for a time with a backgroud music";
    mainProgram  = "pomodoro";
    homepage = "https://github:aristidebm/pomodoro";
    license = lib.licenses.mit;
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];
  postInstall = ''
  '';
}

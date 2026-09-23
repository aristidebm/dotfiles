{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "apic";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "aristidebm";
    repo = "apic";
    rev = "1bb0d354cc0c3546e432c997739a505a30f9b795";
    hash = "sha256-0u6b68ZvhjoSAKTgtPiMfCVQA9y7qFGedPsgqcyIuTs=";
  };
  vendorHash = "sha256-HPadg7C9PNhq0sDMiEcpDOeJ6tef/CyLAnRt2LGvYt8=";
  meta = {
    description = "An curl compatible API client that lets you import form openapi.yml export requests to .curl, .http and organise you api requests into sessions";
    mainProgram  = "apic";
    homepage = "https://github:aristidebm/apic";
    license = lib.licenses.mit;
  };
  postInstall = ''
  '';
}

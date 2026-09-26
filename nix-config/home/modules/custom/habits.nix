# TODO: Make it work
{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go_1_25,
}:

buildGoModule (finalAttrs: {
  pname = "habits";
  go = go_1_25;
  version = "0.1.0";
  vendorHash = "sha256-0FPXA2/E92L/0P4c4VZ5c2aAOZwL03nKgPZHDceJMas=";
  src = fetchFromGitHub {
    owner = "aristidebm";
    repo = "habits";
    rev = "08f643e0f8105fd2529d870b546eb480c5846d71";
    hash = "sha256-cj1lNde7ndbd/4PHWTmlDIycVzgz73wW7LrwflK0Wqg=";
  };
  postInstall = ''
    mv $out/bin/cmd $out/bin/habits
  '';
  meta = {
    description = "A terminal-based habit tracking application with calendar views, multiple habit types, and note-taking capabilities.";
    mainProgram = "habits";
    homepage = "https://github.com/aristidebm/habits";
    license = lib.licenses.mit; };
})

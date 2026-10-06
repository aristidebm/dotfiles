{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "deja";
  version = "0.21.7";

  src = fetchFromGitHub {
    owner = "vshulcz";
    repo = "deja-vu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kAsh37XtdYh952/jMCyj09CCrjiY6aN4Vi3Itj7BBbQ=";
  };

  # go.mod declares no dependencies, so there is nothing to vendor
  vendorHash = null;

  subPackages = [ "cmd/deja" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  # opencode indexing shells out to the sqlite3 CLI
  postInstall = ''
    wrapProgram $out/bin/deja \
      --suffix PATH : ${lib.makeBinPath [ sqlite ]}
  '';

  doCheck = false;

  meta = {
    description = "Local memory layer for coding agents: search, MCP recall and hooks over existing session history";
    homepage = "https://github.com/vshulcz/deja-vu";
    license = lib.licenses.mit;
    mainProgram = "deja";
  };
})

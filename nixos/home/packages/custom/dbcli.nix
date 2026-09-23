{
 lib,
 fetchFromGitHub,
 buildGoModule
}:

buildGoModule (finalAttrs: {
    pname = "dbcli";
    version = "0.1.0";
    vendorHash = "sha256-YuoXOeWfu9bOkqIgnZ5xJm+Y6E0+wmnGnW7mY8feovc=";
    src = fetchFromGitHub {
      owner = "aristidebm";
      repo = "db-cli";
      rev = "6c069de824f7c1403acf03ddeee3554f6d02a467";
      hash = "sha256-yJb1aI8riWKMyOf66g538B1hRObkwBTarQIedasCuYk=";
    };
    postInstall = ''
      mv $out/bin/db $out/bin/dbcli
    '';
    meta = {
      description = "A CLI tool for databases";
      license = lib.licenses.mit;
    };
  })


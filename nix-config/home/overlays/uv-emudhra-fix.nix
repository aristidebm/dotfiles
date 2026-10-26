# https://discuss.python.org/t/information-for-python-users-regarding-emudhra-emsign-ca-certificate-security-incident/109576/53
# This overlay is trying to fix emudhura CA issue in uv
# FIXME: To be removed after upgrading the system into new version
final: prev: {
  uv = prev.uv.overrideAttrs (finalAttrs: old: {
    version = "0.13.4";

    src = prev.fetchFromGitHub {
      owner = "astral-sh";
      repo = "uv";
      tag = finalAttrs.version; # uv tags have no "v" prefix
      hash = "sha256-US3SjwhWE3v4/i46YuBon2GA6PupC4Z0NRUqcV9CPLM=";
    };

    # uv is a buildRustPackage: overriding src alone does NOT refresh the
    # vendored crates, so cargoDeps must be rebuilt explicitly.
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      name = "uv-${finalAttrs.version}-vendor";
      hash = "sha256-9L47CTlkOVYfGuzE4e7e2FYAI192pAsipzzScF7B1j4=";
    };
  });
}

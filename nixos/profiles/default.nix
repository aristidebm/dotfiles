{
  pkgs,
  lib,
}:

let
  cli = pkgs.callPackage ./packages/cli.nix {};
  media = pkgs.callPackage ./packages/media.nix {};
  languages = pkgs.callPackage ./packages/languages.nix {};
  processors = pkgs.callPackage ./packages/processors.nix {};
  ai = pkgs.callPackage ./packages/ai.nix {};
in

pkgs.buildEnv {
  name = "Non NixOS Working Envrionment";
  paths = cli ++ media ++ languages ++ ai ++ processors;
}

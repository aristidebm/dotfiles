{ ... }:

{
  nixpkgs.overlays = [
    (import ./mango-portal-fix.nix)
  ];
}
